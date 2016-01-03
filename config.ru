puts '~~~ TRACKODORO ~~~'

require 'sinatra'
require 'yaml'
require 'data_mapper'

CONFIG =  YAML.load_file('config.yml')

require 'sinatra/reloader' if CONFIG['development']

DataMapper::setup(:default, "sqlite3:///#{CONFIG['database']}")

require File.expand_path '../app.rb', __FILE__

run Trackodoro
