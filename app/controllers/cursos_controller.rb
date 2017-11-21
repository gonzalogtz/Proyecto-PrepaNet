class CursosController < ApplicationController
    def send_cursos_by_tutor()
        cursos = get_cursos_by_tutor(params[:tutor_id])
        
        cursos_arr = []
        cursos.each do |curso|
            cursos_arr.push([curso.grupo, curso.materia])
        end
        
        respond_to do |format|
            format.js {render :json => cursos_arr}
        end
    end

    def import
        Curso.import(params[:file])
        redirect_to root_url, notice: "Cursos importados."
     end
end