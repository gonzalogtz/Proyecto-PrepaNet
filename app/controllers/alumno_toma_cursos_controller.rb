class AlumnoTomaCursosController < ApplicationController
    def import
        AlumnoTomaCurso.import(params[:file])
        redirect_to root_url, notice: "Alumno en Cursos importados."
     end
end
