class Alumno < ApplicationRecord
    require 'csv'
    
        CSV_MAP = {
           'Matricula' => 'matricula' ,
           'Nombres' => 'nombres',
           'A.Paterno' => 'apellido_p',
           'A.Materno' => 'apellido_m',
           'E-mail' => 'correo',
           'Tel. Directo' => 'telefono',
        }
    
        def self.import(file)
            summary_hash = {"nuevos" => [], "editados" => []}
            CSV.foreach(file.path, headers:true, encoding: 'iso-8859-1:utf-8') do |row|
                user_hash = row.to_hash
    
                attributes = CSV_MAP.each_with_object({}) do |(csv_key, attribute_key), result|
                    result[attribute_key] = row[csv_key]
                end
                
                attributes["matricula"] = attributes["matricula"].upcase
                user = Alumno.where('upper(matricula) = ?', attributes["matricula"])
                
                if user.count == 1
                    summary_hash["editados"].push(attributes["matricula"])
                    user.first.update_attributes(attributes)
                else
                    summary_hash["nuevos"].push(attributes["matricula"])
                    Alumno.create!(attributes)
                end
            end
            
            return summary_hash
        end
end