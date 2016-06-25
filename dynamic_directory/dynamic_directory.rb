require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"

get "/" do
  @title = "File List"
  @files = Dir.glob('public/*.txt').map { |file| file[7..-1]}
  erb :home
end
