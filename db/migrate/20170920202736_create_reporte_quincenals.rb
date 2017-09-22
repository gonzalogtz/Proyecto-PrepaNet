class CreateReporteQuincenals < ActiveRecord::Migration[5.0]
  def change
    create_table :reporte_quincenals do |t|
      t.string :estatus
      t.string :localizado
      t.string :comentarios
      t.string :tutor
      t.string :alumno
      t.datetime :fecha

      t.timestamps
    end
  end
end
