class ModifyCalificacionConglomeradoQuincenals < ActiveRecord::Migration[5.0]
  def change
    change_column :conglomerado_quincenals, :calificaciones, :string
  end
end
