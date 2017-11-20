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
        CSV.foreach(file.path, headers:true, encoding: 'iso-8859-1:utf-8') do |row|
            user_hash = row.to_hash

            attributes = CSV_MAP.each_with_object({}) do |(csv_key, attribute_key), result|
                result[attribute_key] = row[csv_key]
            end
            
            user = Usuario.where(cuenta: attributes["cuenta"])
            attributes["periodo"] = Periodo.where(activo: 1).first.id
            
            if user.count == 1
                user.first.update_attributes(attributes)
            else
                Usuario.create!(attributes)
            end
        end
    end
end