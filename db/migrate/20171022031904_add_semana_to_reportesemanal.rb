class AddSemanaToReportesemanal < ActiveRecord::Migration[5.0]
  def change
    add_column :reporte_semanals, :semana, :integer
  end
end