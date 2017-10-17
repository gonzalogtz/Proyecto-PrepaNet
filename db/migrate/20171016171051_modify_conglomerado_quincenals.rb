class ModifyConglomeradoQuincenals < ActiveRecord::Migration[5.0]
  def change
    add_column :conglomerado_quincenals, :calificaciones, :integer, default: [], array: true
    add_column :conglomerado_quincenals, :promedio, :integer
    add_column :conglomerado_quincenals, :horas_desemp, :integer
    add_column :conglomerado_quincenals, :alumnos_acabaron, :integer
    add_column :conglomerado_quincenals, :horas_reportes, :integer
    add_column :conglomerado_quincenals, :total_horas, :integer
    add_column :conglomerado_quincenals, :total_horas_sugerido, :integer
  end
end
