require 'sinatra'
require 'sinatra/reloader'
require 'tilt/erubis'
require 'yaml'
require 'pry'

before do
  @users = YAML.load_file "users.yaml"
end

not_found do
  redirect '/'
end

get "/" do
  redirect "/users"
end

get "/users" do
  erb :users
end
