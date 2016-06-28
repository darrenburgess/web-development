require 'sinatra'
require 'sinatra/reloader'
require 'tilt/erubis'
require 'yaml'
require 'pry'

get '/' do
  users = begin
            YAML.load(File.open("/users.yml"))
          rescue ArgumentError => e
            puts "could not parse YAML: #{e.message}"
          end
end
