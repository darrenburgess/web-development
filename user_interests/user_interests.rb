require 'sinatra'
require 'sinatra/reloader'
require 'tilt/erubis'
require 'yaml'
require 'pry'

before do
  @users = YAML.load_file "users.yaml"
  @user_count = @users.size
end

helpers do
  def count_interests
    interest_count = 0
    @users.each do |_ , hash|
      interest_count = interest_count + hash[:interests].size
    end
    interest_count
  end
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

get "/user/:name" do
  @name = params["name"].to_sym
  @user = @users.select { |key, _| key == @name }
  redirect "/" if @user.empty?
  @interests = @user[@name][:interests].join ", "
  @other_users = @users.select { |key, _| key != @name }
  erb :user
end
