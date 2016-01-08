puts '~~~ TRACKODORO ~~~'

require 'sinatra'
require 'yaml'
require 'data_mapper'
require 'sqlite3'
require 'sequel'
require 'sequel_secure_password'
require 'warden'
require 'bcrypt'

CONFIG =  YAML.load_file('config.yml')

require 'sinatra/reloader' if CONFIG['development']

DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/#{CONFIG['database']}")

require File.expand_path '../app.rb', __FILE__

require './models.rb'

run Trackodoro
