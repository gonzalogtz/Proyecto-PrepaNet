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
        summary_hash = {"nuevos" => [], "editados" => []}
        periodo_activo = Periodo.where(activo: 1).first.id
        CSV.foreach(file.path, headers:true, encoding: 'iso-8859-1:utf-8') do |row|
            curso_hash = row.to_hash

            attributes = CSV_MAP.each_with_object({}) do |(csv_key, attribute_key), result|
                result[attribute_key] = row[csv_key]
            end
            
            attributes["grupo"] = attributes["grupo"].upcase
            curso = Curso.where('upper(grupo) = ?', attributes["grupo"])
            attributes["periodo"] = periodo_activo
            
            if curso.count == 1
                summary_hash["editados"].push(attributes["grupo"])
                curso.first.update_attributes(attributes)
            else
                summary_hash["nuevos"].push(attributes["grupo"])
                Curso.create!(attributes)
            end
        end
        
        return summary_hash
    end
end