class ApplicationController < ActionController::Base
  include ActionView::Helpers::UrlHelper
  protect_from_forgery with: :exception

  USUARIO = ""
  USER_ID = ""
  ROLE = ""
  FORMATO_FECHA = "%-d/%-m/%Y"

    def get_usuario_name_by_id(id)
      usuario = User.where(userid: id).first
      return usuario.names + " " + usuario.flname
    end
    helper_method :get_usuario_name_by_id
    
    def user_is_logged_in
      if (USUARIO == "" && !current_page?("/"))
        redirect_to "/"
      end
    end
    
end