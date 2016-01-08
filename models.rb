DB = Sequel.connect('sqlite://db/trackodoro.db')

class User < Sequel::Model
  plugin :secure_password
end

DB.create_table! :users do
  primary_key :id
  String      :email
  String      :password_digest
end

require './populate.rb' if CONFIG['development']
