require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"

get "/" do
  @title = "File List"
  @files = Dir.glob('public/*.txt')
  erb :home
end

get "/public/1" do
  @file_name = "test1.txt"
  @content = File.read "public/test1.txt"
  erb :file
end
