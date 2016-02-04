# MIGRATIONS

if !File.exists?("#{CONFIG['database']}")

  # IF YOU DO CHANGES HERE, DELETE THE FILE 'db/pomospace.db'

  DB = Sequel.connect("sqlite://#{CONFIG['database']}")

  DB.create_table :users do
    primary_key :id
    String      :email
    String      :password_digest
    String      :first_name
    String      :last_name
    TrueClass   :is_activated
    String      :motivation, :size=>140
  end

  DB.create_table :pomodoros do
    primary_key :id
    DateTime    :h
    foreign_key :user_id
  end

  DB.create_table :tags do
    primary_key :id
    String      :title
    #String      :color
  end

  DB.create_join_table(:pomodoro_id=>:pomodoros, :tag_id=>:tags)

  just_created = true
else
  DB = Sequel.connect("sqlite://#{CONFIG['database']}")
end


# USERS

class User < Sequel::Model
  plugin :secure_password
  one_to_many :pomodoros
end

# POMODOROS

class Pomodoro < Sequel::Model
  many_to_one :user
  many_to_many :tags
end

# TAGS

class Tag < Sequel::Model
  many_to_many :pomodoros
end

require './populate.rb' if CONFIG['development'] if just_created
