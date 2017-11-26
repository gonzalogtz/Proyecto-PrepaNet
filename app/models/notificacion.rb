class Notificacion < ApplicationRecord
    self.table_name = "notificaciones"
    
    def self.crear_notificacion(usuario, mensaje, liga)
        notificacion = Notificacion.new(usuario: usuario, mensaje: mensaje, liga: liga, leida: 0)
        notificacion.save
    end
end