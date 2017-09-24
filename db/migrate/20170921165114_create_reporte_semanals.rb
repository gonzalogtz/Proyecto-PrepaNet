class CreateReporteSemanals < ActiveRecord::Migration[5.0]
  def change
    create_table :reporte_semanals do |t|
      t.string :tutor
      t.string :califPlazo
      t.string :califRubrica
      t.string :retro
      t.string :responde
      t.string :errores
      t.text :comentarios

      t.timestamps
    end
  end
end
