class Usuario < ApplicationRecord
    require 'csv'

    CSV_MAP = {
       'Cuenta' => 'cuenta',
       'Nomina/Matricula' => 'nomina_matricula' ,
       'Contrasena' => 'contrasena',
       'Campus' => 'campus', 
       'Rol' => 'rol',
       'Titulo' => 'titulo',
       'Nombres' => 'nombres',
       'A.Paterno' => 'apellido_p',
       'A.Materno' => 'apellido_m',
       'E-mail' => 'correo',
       'Tel. Directo' => 'telefono',
       'Periodo' => 'periodo',
    }

    def self.import(file)
        summary_hash = {"nuevos" => [], "editados" => []}
        periodo_activo = Periodo.where(activo: 1).first.id
        CSV.foreach(file.path, headers:true, encoding: 'iso-8859-1:utf-8') do |row|
            user_hash = row.to_hash

            attributes = CSV_MAP.each_with_object({}) do |(csv_key, attribute_key), result|
                result[attribute_key] = row[csv_key]
            end
            
            attributes["cuenta"] = attributes["cuenta"].upcase
            user = Usuario.where('upper(cuenta) = ?', attributes["cuenta"])
            attributes["periodo"] = periodo_activo
            
            if user.count == 1
                summary_hash["editados"].push(attributes["cuenta"])
                user.first.update_attributes(attributes)
            else
                summary_hash["nuevos"].push(attributes["cuenta"])
                Usuario.create!(attributes)
            end
        end
        
        return summary_hash
    end
end