class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :userid
      t.string :password
      t.string :campus
      t.string :role
      t.string :names
      t.string :flname
      t.string :slname
      t.string :email
      t.string :phone
      t.string :status

      t.timestamps
    end
  end
end
