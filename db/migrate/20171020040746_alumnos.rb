class Alumnos < ActiveRecord::Migration[5.0]
  def change
    create_table :alumnos do |t|
      t.string :id_tutor
      t.string :nombre
      t.string :matricula
      t.timestamps
    end
  end
end
