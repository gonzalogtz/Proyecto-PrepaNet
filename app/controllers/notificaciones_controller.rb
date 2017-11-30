class NotificacionesController < ApplicationController
    def get_notificaciones
        notificaciones = Notificacion.where(usuario: session[:cuenta]).order('created_at desc')

        respond_to do |format|
            format.js {render :json => notificaciones}
        end
    end

    def get_num_notificaciones
        num_notificaciones = Notificacion.where(usuario: session[:cuenta], leida: 0).count

        respond_to do |format|
            format.js {render :json => num_notificaciones}
        end
    end
    
    def set_notificaciones_leida
        if (params[:id_notif] == "-1")
            Notificacion.where(usuario: session[:cuenta], leida: 0).update_all(leida: 1)
        else
            Notificacion.update(params[:id_notif], leida: 1)
        end
    end
end