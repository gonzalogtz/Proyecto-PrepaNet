class Usuario < ApplicationRecord
<<<<<<< HEAD
    require 'csv'
    def self.import(file)
        CSV.foreach(file.path, headers:true) do |row|
            user_hash = row.to_hash
            user = Usuario.where(id: user_hash["userid"])
            
            if user.count == 1
                user.first.update_attributes(user_hash)
            else
                Usuario.create!(user_hash)
            end
        end
    end
=======
>>>>>>> 49c9dd963a5072acdc75142e62ddb7376178f440
end