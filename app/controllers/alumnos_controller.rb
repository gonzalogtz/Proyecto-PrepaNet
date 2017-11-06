class AlumnosController < ApplicationController
    def send_alumnos_by_curso()
        alumnos = get_alumnos_by_curso(params[:curso_id])
        
        alumnos_arr = []
        alumnos.each do |alumno|
            nombre = alumno.nombres + " " + alumno.apellido_p + " " + alumno.apellido_m
            alumnos_arr.push([alumno.matricula, nombre])
        end
        
        respond_to do |format|
            format.js {render :json => alumnos_arr}
        end
    end
end