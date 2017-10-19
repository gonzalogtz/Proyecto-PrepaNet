class ModifyCalificacionConglomeradoQuincenals2 < ActiveRecord::Migration[5.0]
  def change
    add_column :conglomerado_quincenals, :coordinador_tutores, :integer
    add_column :conglomerado_quincenals, :alumnos_aprobaron, :integer
    add_column :conglomerado_quincenals, :alumnos_final_concluyeron, :integer

  end
end
