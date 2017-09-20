class CreateConglomeradoQuincenals < ActiveRecord::Migration[5.0]
  def change
    create_table :conglomerado_quincenals do |t|
      t.string :materia
      t.string :tutor
      t.string :invito
      t.string :rparcial
      t.string :rfinal
      t.text :resumen
      t.string :cierre
      t.string :reingresar
      t.string :recomendacion

      t.timestamps
    end
  end
end
