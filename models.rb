DB = Sequel.connect('sqlite://db/trackodoro.db')

# USERS

class User < Sequel::Model
  plugin :secure_password
  one_to_many :pomodoros
end

DB.create_table! :users do
  primary_key :id
  String      :email
  String      :password_digest
  String      :first_name
  String      :last_name
end


# POMODOROS

class Pomodoro < Sequel::Model
  many_to_one :user
  many_to_many :tags
end

DB.create_table! :pomodoros do
  primary_key :id
  DateTime    :h
  foreign_key :user_id
end


# TAGS

class Tag < Sequel::Model
  many_to_many :pomodoros
end

DB.create_table! :tags do
  primary_key :id
  String      :title
  #String      :color
end

DB.create_join_table(:pomodoro_id=>:pomodoros, :tag_id=>:tags)


require './populate.rb' if CONFIG['development']
