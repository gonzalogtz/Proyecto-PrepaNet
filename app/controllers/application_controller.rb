class ApplicationController < ActionController::Base
  include ActionView::Helpers::UrlHelper
  protect_from_forgery with: :exception

  FORMATO_FECHA = "%-d/%-m/%Y"
  STR_ROL_TUTOR = "Tutor"
  STR_ROL_COORDINADOR_TUTOR = "Coordinador de Tutores"
  STR_ROL_TUTOR_STAFF = "Tutor Staff"
  STR_ROL_COORDINADOR_CAMPUS = "Coordinador Prepanet Campus"
  STR_ROL_COORDINADOR_PREPANET = "Director Prepanet Nacional"
  STR_ROL_COORDINADOR_INFORMATICA = "Coordinador Informatica Prepanet"

    def get_usuario_name_by_cuenta(id)
      usuario = Usuario.select(:nombres, :apellido_p, :apellido_m).where(cuenta: id).first
      return usuario.nombres + " " + usuario.apellido_p + " " + usuario.apellido_m
    end
    helper_method :get_usuario_name_by_cuenta
    
    def get_alumno_name_by_matricula(id)
      alumno = Alumno.select(:nombres, :apellido_p, :apellido_m).where(matricula: id).first
      
      if alumno
        return alumno.nombres + " " + alumno.apellido_p + " " + alumno.apellido_m
      else
        return "<b style='color: #C03A2B'>Alumno inexistente</b>".html_safe
      end
    end
    helper_method :get_alumno_name_by_matricula
    
    def get_matricula_by_cuenta(cuenta)
      usuario = Usuario.select(:nomina_matricula).where(cuenta: cuenta).first
      return usuario.nomina_matricula
    end
    helper_method :get_matricula_by_cuenta
    
    def get_cursos_by_tutor(tutor_id = session[:cuenta], periodo = get_periodo_activo())
      cursos = Curso.where(tutor: tutor_id, periodo: periodo).order('grupo')
      return cursos
    end
    helper_method :get_cursos_by_tutor
    
    def get_cursos_encargados()
      periodo_actual = get_periodo_activo()
      
      if session[:rol] == STR_ROL_TUTOR
        cursos = Curso.where(tutor: session[:cuenta], periodo: periodo_actual)
      elsif session[:rol] == STR_ROL_COORDINADOR_TUTOR
        cursos = Curso.where(coordinador_tutores: session[:cuenta], periodo: periodo_actual)
      elsif session[:rol] == STR_ROL_COORDINADOR_CAMPUS
        cursos = Curso.where(campus: session[:campus], periodo: periodo_actual)
      elsif session[:rol] == STR_ROL_COORDINADOR_INFORMATICA || session[:rol] == STR_ROL_COORDINADOR_PREPANET
        cursos = Curso.where(periodo: periodo_actual)
      end
      
      return cursos.order('grupo')
    end
    helper_method :get_cursos_encargados

    def get_alumnos_by_curso(curso_id)
      alumnos = AlumnoTomaCurso.select("*").where(curso: curso_id).joins("INNER JOIN alumnos ON alumno_toma_cursos.alumno = alumnos.matricula")
      return alumnos.order('matricula')
    end
    helper_method :get_alumnos_by_curso
    
    def get_tutores_encargados()
      periodo_actual = get_periodo_activo()
      
      if session[:rol] == STR_ROL_COORDINADOR_TUTOR
        tutores = Curso.select("usuarios.cuenta, usuarios.nombres, usuarios.apellido_p, usuarios.apellido_m, usuarios.nomina_matricula").where(coordinador_tutores: session[:cuenta], periodo: periodo_actual).joins("INNER JOIN usuarios ON cursos.tutor = usuarios.cuenta").distinct
      elsif session[:rol] == STR_ROL_COORDINADOR_CAMPUS
        tutores = Usuario.where(campus: session[:campus], rol: STR_ROL_TUTOR, periodo: periodo_actual)
      elsif session[:rol] == STR_ROL_COORDINADOR_INFORMATICA || session[:rol] == STR_ROL_COORDINADOR_PREPANET
        tutores = Usuario.where(periodo: periodo_actual, rol: STR_ROL_TUTOR)
      end
      
      return tutores.order('cuenta')
    end
    helper_method :get_tutores_encargados
    
    def get_tutores_by_campus(campus_id, periodo)
      tutores = Usuario.where(campus: campus_id, rol: STR_ROL_TUTOR, periodo: periodo)
      return tutores.order('cuenta')
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
      if !curso.is_a?(ActiveRecord::Base)
        curso = Curso.where(grupo: curso).first
      end
      
      texto = curso.materia + " - " + curso.grupo
      return texto
    end
    helper_method :get_texto_header_curso
    
    def get_nombre_curso(curso)
      curso = Curso.select(:materia).where(grupo: curso).first
      
      if curso
        return curso.materia
      else
        return "<b style='color: #C03A2B'>Materia inexistente</b>".html_safe
      end
    end
    helper_method :get_nombre_curso
    
    def get_num_grupo(clave_grupo)
      partes_grupo = clave_grupo.split('.')
      return partes_grupo[-1]
    end
    
    def get_campus(periodo_id)
      campus = Curso.select('DISTINCT campus').where(periodo: periodo_id)
      return campus.order('campus')
    end
    helper_method :get_campus
    
    def get_periodos()
      #orden: primero el activo, después antiguos en orden de calendario
      periodos = Periodo.select(:descripcion, :id).all
      return periodos.order('activo desc, inicio_periodo')
    end
    helper_method :get_periodos
    
    def get_periodo_activo()
      periodo_actual = Periodo.where(activo: 1).first
      
      if !periodo_actual
        return -1
      else
        return periodo_actual.id
      end
    end
    helper_method :get_periodo_activo
    
    def get_descripcion_periodo(periodo_id)
      if periodo_id == -1
        return "Sin periodo"
      end
      
      descripcion = Periodo.find(periodo_id)
      return descripcion.descripcion
    end
    helper_method :get_descripcion_periodo
    
    def get_notificacion_icon()
        num_notificaciones = Notificacion.where(usuario: session[:cuenta], leida: 0).count
        
        if num_notificaciones > 0
            return "new_notification_icon.png"
        else
            return "notification_icon.png"
        end
	  end
	  helper_method :get_notificacion_icon
  
    def user_is_logged_in()
      if (!session[:nombre_usuario] && !current_page?("/"))
        redirect_to "/"
      end
    end
    
    def user_is_coordinador_informatica()
      if (session[:rol] != STR_ROL_COORDINADOR_INFORMATICA)
        redirect_to "/menuerror"
      end
    end
    helper_method :user_is_coordinador_informatica
    
end