class AlumnoTomaCurso < ApplicationRecord
    require 'csv'

    CSV_MAP = {
        'Alumno' => 'alumno',
        'Grupo' => 'curso'
    }

    def self.import(file)
        summary_hash = {"nuevos" => [], "repetidos" => [], "errores" => []}
        
        CSV.foreach(file.path, headers:true, encoding: 'iso-8859-1:utf-8') do |row|
            attributes = CSV_MAP.each_with_object({}) do |(csv_key, attribute_key), result|
                result[attribute_key] = row[csv_key]
            end
            
            attributes["alumno"] = attributes["alumno"].upcase
            attributes["curso"] = attributes["curso"].upcase
            alumno = Alumno.where('upper(matricula) = ?', attributes["alumno"])
            curso = Curso.where('upper(grupo) = ?', attributes["curso"])
            
            #Si no existe el alumno o el curso indicar el error
            if alumno.count == 1 && curso.count == 1
                alumno_curso = AlumnoTomaCurso.where('upper(alumno) = ? AND upper(curso) = ?', attributes["alumno"], attributes["curso"])
                #Solo agregar si no existe
                if alumno_curso.count != 1
                    summary_hash["nuevos"].push({"alumno" => attributes["alumno"], "curso" => attributes["curso"]})
                    AlumnoTomaCurso.create!(attributes)
                else
                    summary_hash["repetidos"].push({"alumno" => attributes["alumno"], "curso" => attributes["curso"]})
                end
            else
                summary_hash["errores"].push({"alumno" => attributes["alumno"], "curso" => attributes["curso"]})
            end
        end
        
        return summary_hash
    end
end