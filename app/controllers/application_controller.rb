class ApplicationController < ActionController::Base
  include ActionView::Helpers::UrlHelper
  protect_from_forgery with: :exception

  NOMBRE_USUARIO = ""
  CUENTA = ""
  ROL = ""
  FORMATO_FECHA = "%-d/%-m/%Y"
  STR_ROL_TUTOR = "Tutor"
  STR_ROL_COORDINADOR_TUTOR = "Coordinador de Tutor"
  STR_ROL_COORDINADOR_PREPANET = "Coordinador Prepanet"

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
    
    def get_alumnos_by_curso(curso_id)
      alumnos = AlumnoCursaMateria.select("*").where(curso: curso_id).joins("INNER JOIN alumnos ON alumno_cursa_materias.alumno = alumnos.matricula")
      return alumnos
    end
    helper_method :get_alumnos_by_curso
    
    def get_tutores_by_coordinador_tutores(coordinador_id = CUENTA)
      tutores = UsuarioCoordinaUsuario.select("*").where(coordinador: CUENTA).joins("INNER JOIN usuarios ON usuario_coordina_usuarios.usuario = usuarios.cuenta")
      return tutores
    end
    helper_method :get_tutores_by_coordinador_tutores
  
    def user_is_logged_in
      if (NOMBRE_USUARIO == "" && !current_page?("/"))
        redirect_to "/"
      end
    end
    
end