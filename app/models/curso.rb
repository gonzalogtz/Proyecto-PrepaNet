class Curso < ApplicationRecord
    require 'csv'

    CSV_MAP = {
        'Campus' => 'campus',
        'Curso' => 'materia',
        'Grupo' => 'grupo',
        'Tutor' => 'tutor',
        'Coordinador de Tutores' => 'coordinador_tutores'
    }

    def self.import(file)
        CSV.foreach(file.path, headers:true, encoding: 'iso-8859-1:utf-8') do |row|
            curso_hash = row.to_hash
            curso = Curso.where(grupo: curso_hash["grupo"])

            attributes = CSV_MAP.each_with_object({}) do |(csv_key, attribute_key), result|
                result[attribute_key] = row[csv_key]
            end
            
            attributes["periodo"] = Periodo.where(activo: 1).first.id
            
            if curso.count == 1
                curso.first.update_attributes(attributes)
            else
                Curso.create!(attributes)
            end
        end
    end
end