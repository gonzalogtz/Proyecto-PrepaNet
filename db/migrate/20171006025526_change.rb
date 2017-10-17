class Change < ActiveRecord::Migration[5.0]
  def change
    change_column :reporte_semanals, :califPlazo, :integer
    change_column :reporte_semanals, :califRubrica, :integer
    change_column :reporte_semanals, :retro, :integer
    change_column :reporte_semanals, :responde, :integer
    change_column :reporte_semanals, :errores, :integer
    add_column :reporte_semanals, :total, :integer

  end
end
