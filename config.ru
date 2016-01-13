puts '~~~ TRACKODORO ~~~'

require 'sinatra'
require 'yaml'
require 'sequel'
require 'sequel_secure_password'
require 'warden'

CONFIG =  YAML.load_file('config.yml')

require 'sinatra/reloader' if CONFIG['development']

require File.expand_path '../app.rb', __FILE__

require './models.rb'

run Trackodoro
