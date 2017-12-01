class ReporteSemanal < ApplicationRecord
    def calcular_calif_total
        self[:calificacion_total] = self[:califica_en_plazo] + self[:califica_con_rubrica] + self[:da_retroalimentacion] + self[:responde_mensajes] + self[:errores_ortografia]
    end
end