class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  USUARIO = ""
  USER_ID = ""
  ROLE = ""

    def get_usuario_name_by_id(id)
      usuario = User.where(userid: id).first
      return usuario.names + " " + usuario.flname
    end
    helper_method :get_usuario_name_by_id
    
end