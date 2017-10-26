json.extract! user, :id, :userid, :password, :campus, :role, :names, :flname, :slname, :email, :phone, :status, :created_at, :updated_at
json.url user_url(user, format: :json)
