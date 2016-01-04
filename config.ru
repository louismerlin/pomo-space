puts '~~~ TRACKODORO ~~~'

require 'sinatra'
require 'yaml'
require 'data_mapper'
require 'warden'
require 'bcrypt'

CONFIG =  YAML.load_file('config.yml')

require 'sinatra/reloader' if CONFIG['development']

DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/#{CONFIG['database']}")

require File.expand_path '../app.rb', __FILE__

run Trackodoro
