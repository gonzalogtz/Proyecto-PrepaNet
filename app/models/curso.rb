class Curso < ApplicationRecord
    CSV_MAP = {
        'Campus' => 'campus',
        'Curso' => 'clave_materia',
        'Grupo' => 'grupo',
    }

    def self.import(file)
        CSV.foreach(file.path, headers:true) do |row|
            curso_hash = row.to_hash
            curso = Curso.where(grupo: curso_hash["grupo"])

            attributes = CSV_MAP.each_with_object({}) do |(csv_key, attribute_key), result|
                result[attribute_key] = row[csv_key]
            end
            
            if curso.count == 1
                curso.first.update_attributes(attributes)
            else
                Curso.create!(attributes)
            end
        end
    end
end