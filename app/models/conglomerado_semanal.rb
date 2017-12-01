class ConglomeradoSemanal < ApplicationRecord
    def calcular_datos_semanal
        # Variables calculadas a partir de los reportes semanales
        reportes_semanales = ReporteSemanal.where(tutor: self[:tutor], curso: self[:curso]).order('semana').take(15)
        
        #Se leen las 15 calificaciones de los reportes semanales
        calif_arr = []
        reportes_semanales.each do |reporte|
            calif_arr.push(reporte.calificacion_total)
        end
        
        self[:calificaciones_semanales] = calif_arr.to_json()
        self[:promedio] = calif_arr.sum.fdiv(calif_arr.size)
        self[:horas_desempeno_semanal] =  (self[:promedio]*7.5).ceil
    end
    
    def calcular_horas
        self[:total_horas] =  self[:horas_desempeno_semanal] + self[:horas_reportes]
    end
end