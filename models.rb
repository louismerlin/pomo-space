DB = Sequel.connect('sqlite://db/trackodoro.db')

# USERS

class User < Sequel::Model
  plugin :secure_password
  one_to_many :pomodoro
end

DB.create_table! :users do
  primary_key :id
  String      :email
  String      :password_digest
end


# POMODOROS

class Pomodoro < Sequel::Model
  many_to_one :user
  many_to_many :tag
end

DB.create_table! :pomodoro do
  primary_key :id
  DateTime    :h
end


# TAGS

class Tag < Sequel::Model
  many_to_many :pomodoro
end

DB.create_table! :tag do
  primary_key :id
  String      :title
  #String      :color
end


require './populate.rb' if CONFIG['development']
