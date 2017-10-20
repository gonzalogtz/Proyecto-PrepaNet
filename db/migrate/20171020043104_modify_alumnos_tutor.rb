class ModifyAlumnosTutor < ActiveRecord::Migration[5.0]
  def change
    rename_column :alumnos, :id_tutor, :tutor
  end
end
