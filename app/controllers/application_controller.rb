class ApplicationController < ActionController::Base
  include ActionView::Helpers::UrlHelper
  protect_from_forgery with: :exception

  NOMBRE_USUARIO = ""
  CUENTA = ""
  ROL = ""
  FORMATO_FECHA = "%-d/%-m/%Y"

    def get_usuario_name_by_id(id)
      usuario = Usuario.where(cuenta: id).first
      return usuario.nombres + " " + usuario.apellido_p
    end
    helper_method :get_usuario_name_by_id
    
    def user_is_logged_in
      if (NOMBRE_USUARIO == "" && !current_page?("/"))
        redirect_to "/"
      end
    end
    
end