class ApplicationController < ActionController::Base
  include ActionView::Helpers::UrlHelper
  protect_from_forgery with: :exception

  NOMBRE_USUARIO = ""
  CUENTA = ""
  ROL = ""
  CAMPUS = ""
  PERIODO_ACTUAL = 1
  FORMATO_FECHA = "%-d/%-m/%Y"
  STR_ROL_TUTOR = "Tutor"
  STR_ROL_COORDINADOR_TUTOR = "Coordinador de Tutores"
  STR_ROL_TUTOR_STAFF = "Tutor Staff"
  STR_ROL_COORDINADOR_CAMPUS = "Coordinador Prepanet Campus"
  STR_ROL_COORDINADOR_PREPANET = "Director Prepanet Nacional"
  STR_ROL_COORDINADOR_INFORMATICA = "Coordinador Informatica Prepanet"

    def get_usuario_name_by_id(id)
      usuario = Usuario.select(:nombres, :apellido_p, :apellido_m).where(cuenta: id).first
      return usuario.nombres + " " + usuario.apellido_p
    end
    helper_method :get_usuario_name_by_id
    
    def get_alumno_name_by_id(id)
      alumno = Alumno.select(:nombres, :apellido_p, :apellido_m).where(matricula: id).first
      return alumno.nombres + " " + alumno.apellido_p + " " + alumno.apellido_m
    end
    helper_method :get_alumno_name_by_id
    
    def get_cursos_by_tutor(tutor_id = CUENTA)
      cursos = Curso.where(tutor: tutor_id).order('grupo')
      return cursos
    end
    helper_method :get_cursos_by_tutor
    
    def get_cursos_encargados()
      if ROL == STR_ROL_TUTOR
        cursos = Curso.where(tutor: CUENTA, periodo: PERIODO_ACTUAL)
      elsif ROL == STR_ROL_COORDINADOR_TUTOR
        cursos = Curso.where(coordinador_tutores: CUENTA, periodo: PERIODO_ACTUAL)
      elsif ROL == STR_ROL_COORDINADOR_CAMPUS
        cursos = Curso.where(campus: CAMPUS, periodo: PERIODO_ACTUAL)
      elsif ROL == STR_ROL_COORDINADOR_INFORMATICA || ROL == STR_ROL_COORDINADOR_PREPANET
        cursos = Curso.where(periodo: PERIODO_ACTUAL)
      end
      
      return cursos.order('grupo')
    end
    helper_method :get_cursos_encargados

    def get_alumnos_by_curso(curso_id)
      alumnos = AlumnoTomaCurso.select("*").where(curso: curso_id).joins("INNER JOIN alumnos ON alumno_toma_cursos.alumno = alumnos.matricula")
      return alumnos
    end
    helper_method :get_alumnos_by_curso
    
    def get_tutores_encargados()
      if ROL == STR_ROL_COORDINADOR_TUTOR
        tutores = Curso.select("usuarios.cuenta, usuarios.nombres, usuarios.apellido_p, usuarios.apellido_m").where(coordinador_tutores: CUENTA, periodo: PERIODO_ACTUAL).joins("INNER JOIN usuarios ON cursos.tutor = usuarios.cuenta").distinct
      elsif ROL == STR_ROL_COORDINADOR_CAMPUS
        tutores = Usuario.where(campus: CAMPUS, rol: STR_ROL_TUTOR)
      end
      
      return tutores.order('cuenta')
    end
    helper_method :get_tutores_encargados
    
    def get_tutores_by_campus(campus_id)
      tutores = Usuario.where(campus: campus_id, rol: STR_ROL_TUTOR)
      return tutores
    end
    helper_method :get_tutores_by_campus
    
    def get_tutores_for_select()
      lista_tutores = []
      
      get_tutores_encargados().each do |tutor|
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
    
    def get_campus()
      campus = Curso.select('DISTINCT campus')
      return campus
    end
    helper_method :get_campus
  
    def user_is_logged_in()
      if (NOMBRE_USUARIO == "" && !current_page?("/"))
        redirect_to "/"
      end
    end
    
end