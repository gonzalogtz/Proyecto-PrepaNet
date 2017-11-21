class AlumnoTomaCurso < ApplicationRecord
    require 'csv'

    CSV_MAP = {
        'Campus' => 'campus',
        'Curso' => 'materia',
        'Grupo' => 'grupo',
        'Tutor' => 'tutor',
        'Coordinador de Tutores' => 'coordinador_tutores'
    }

    def self.import(file)

    end
end