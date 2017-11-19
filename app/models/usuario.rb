class Usuario < ApplicationRecord
    require 'csv'

    CSV_MAP = {
       'Cuenta' => 'cuenta',
       'Nómina/Matrícula' => 'nomina_matricula' ,
       'Contraseña' => 'contrasena',
       'Campus' => 'campus', 
       'Rol' => 'rol',
       'Título' => 'titulo',
       'Nombres' => 'nombres',
       'A.Paterno' => 'apellido_p',
       'A.Materno' => 'apellido_m',
       'E-mail' => 'correo',
       'Tel. Directo' => 'telefono',
       'Periodo' => 'periodo',
    }

    def self.import(file)
        CSV.foreach(file.path, headers:true) do |row|
            user_hash = row.to_hash
            user = Usuario.where(cuenta: user_hash["cuenta"])

            attributes = CSV_MAP.each_with_object({}) do |(csv_key, attribute_key), result|
                result[attribute_key] = row[csv_key]
            end
            
            if user.count == 1
                user.first.update_attributes(attributes)
            else
                Usuario.create!(attributes)
            end
        end
    end
end