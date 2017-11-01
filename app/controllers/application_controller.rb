class ApplicationController < ActionController::Base
  include ActionView::Helpers::UrlHelper
  protect_from_forgery with: :exception

  NOMBRE_USUARIO = ""
  CUENTA = ""
  ROL = ""
  FORMATO_FECHA = "%-d/%-m/%Y"
  STR_ROL_TUTOR = "Tutor"
  STR_ROL_COORDINADOR_TUTOR = "Coordinador de Tutor"

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
    
    def user_is_logged_in
      if (NOMBRE_USUARIO == "" && !current_page?("/"))
        redirect_to "/"
      end
    end
    
end