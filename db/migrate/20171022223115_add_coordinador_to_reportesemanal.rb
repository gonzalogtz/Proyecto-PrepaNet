class AddCoordinadorToReportesemanal < ActiveRecord::Migration[5.0]
  def change
    add_column :reporte_semanals, :coordinador_tutores, :string
  end
end
