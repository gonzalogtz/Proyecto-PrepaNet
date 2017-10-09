class AddCoordinadorToconglomerado_quincenals < ActiveRecord::Migration[5.0]
  def change
  	add_column :conglomerado_quincenals, :coordinador ,:string


  end
end
