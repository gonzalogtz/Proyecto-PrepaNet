class AlumnoTomaCursosController < ApplicationController
    def import
        summary = AlumnoTomaCurso.import(params[:file])
        render 'summary_import', locals: {summary: summary}
     end
end
