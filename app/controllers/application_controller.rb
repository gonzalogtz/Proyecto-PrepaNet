class ApplicationController < ActionController::Base
  include ActionView::Helpers::UrlHelper
  protect_from_forgery with: :exception

  NOMBRE_USUARIO = ""
  CUENTA = ""
  ROL = ""
  CAMPUS = ""
  FORMATO_FECHA = "%-d/%-m/%Y"
  STR_ROL_TUTOR = "Tutor"
  STR_ROL_COORDINADOR_TUTOR = "Coordinador de Tutores"
  STR_ROL_TUTOR_STAFF = "Tutor Staff"
  STR_ROL_COORDINADOR_CAMPUS = "Coordinador Prepanet Campus"
  STR_ROL_COORDINADOR_PREPANET = "Director Prepanet Nacional"
  STR_ROL_COORDINADOR_INFORMATICA = "Coordinador Informatica Prepanet"

    def get_usuario_name_by_id(id)
      usuario = Usuario.where(cuenta: id).first
      return usuario.nombres + " " + usuario.apellido_p
    end
    helper_method :get_usuario_name_by_id
    
    def get_alumno_name_by_id(id)
      alumno = Alumno.where(matricula: id).first
      return alumno.nombres + " " + alumno.apellido_p + " " + alumno.apellido_m
    end
    helper_method :get_alumno_name_by_id
    
    def get_coordinador_name_by_coordinado_id(id)
      relacion_coordinador = UsuarioCoordinaUsuario.where(usuario: id).first
      coordinador = Usuario.where(cuenta: relacion_coordinador.coordinador).first
      
      return coordinador.nombres + " " + coordinador.apellido_p
    end
    helper_method :get_coordinador_name_by_coordinado_id
    
    def get_cursos_by_tutor(tutor_id = CUENTA)
      cursos = TutorTutoreaMateria.select("*").where(tutor: tutor_id).joins("INNER JOIN cursos ON tutor_tutorea_materias.curso = cursos.grupo").order('curso')
      return cursos
    end
    helper_method :get_cursos_by_tutor
    
    def get_cursos_encargados()
      if ROL == STR_ROL_TUTOR
        cursos = TutorTutoreaMateria.select("*").where(tutor: CUENTA).joins("INNER JOIN cursos ON tutor_tutorea_materias.curso = cursos.grupo").order('curso')
      elsif ROL == STR_ROL_COORDINADOR_TUTOR
        cursos = UsuarioCoordinaUsuario.select("*").where(coordinador: CUENTA).joins("INNER JOIN tutor_tutorea_materias ON usuario_coordina_usuarios.usuario = tutor_tutorea_materias.tutor INNER JOIN cursos ON tutor_tutorea_materias.curso = cursos.grupo").order('curso')
      elsif ROL == STR_ROL_COORDINADOR_CAMPUS
        cursos = Curso.where(campus: CAMPUS)
      end
    end
    helper_method :get_cursos_encargados

    def get_alumnos_by_curso(curso_id)
      alumnos = AlumnoCursaMateria.select("*").where(curso: curso_id).joins("INNER JOIN alumnos ON alumno_cursa_materias.alumno = alumnos.matricula")
      return alumnos
    end
    helper_method :get_alumnos_by_curso
    
    def get_tutores_encargados
      if ROL == STR_ROL_COORDINADOR_TUTOR
        return get_tutores_by_coordinador_tutores
      elsif ROL == STR_ROL_COORDINADOR_CAMPUS
        return get_tutores_by_coordinador_campus
      end
    end
    helper_method :get_tutores_encargados
    
    def get_tutores_by_coordinador_tutores(coordinador_id = CUENTA)
      tutores = UsuarioCoordinaUsuario.select("*").where(coordinador: CUENTA).joins("INNER JOIN usuarios ON usuario_coordina_usuarios.usuario = usuarios.cuenta")
      return tutores
    end
    helper_method :get_tutores_by_coordinador_tutores
    
    def get_tutores_by_coordinador_campus(coordinador_id = CUENTA)
      coordinador_tutores = UsuarioCoordinaUsuario.where(coordinador: CUENTA)
      
      lista_coordinadores = []
      coordinador_tutores.each do |coordinador_tutor|
        lista_coordinadores.push(coordinador_tutor.usuario)
      end
      
      tutores = UsuarioCoordinaUsuario.select("*").where(coordinador: lista_coordinadores).joins("INNER JOIN usuarios ON usuario_coordina_usuarios.usuario = usuarios.cuenta")

      return tutores
    end
    helper_method :get_tutores_by_coordinador_campus
    
    def get_tutores_for_select
      lista_tutores = []
      
      get_tutores_by_coordinador_tutores().each do |tutor|
        nombre_tutor = tutor.nombres + " " + tutor.apellido_p + " " + tutor.apellido_m
        lista_tutores.push([nombre_tutor, tutor.cuenta])
      end
      
      return lista_tutores
    end
    helper_method :get_tutores_for_select
    
    def get_texto_header_curso(curso)
      texto = curso.materia + " - Grupo "
      texto += get_num_grupo(curso.grupo)
      return texto
    end
    helper_method :get_texto_header_curso
    
    def get_num_grupo(clave_grupo)
      partes_grupo = clave_grupo.split('.')
      return partes_grupo[-1]
    end
  
    def user_is_logged_in
      if (NOMBRE_USUARIO == "" && !current_page?("/"))
        redirect_to "/"
      end
    end
    
end