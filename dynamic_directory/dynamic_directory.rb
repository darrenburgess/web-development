require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"
require "pry"

get "/" do
  @title = "File List"
  @files = Dir.glob('public/*.txt').map { |file| file[7..-1] }
  @sort = @params["sort"]

  if @sort == "descending"
    @files.reverse!
  else
    @files.sort!
  end

  erb :home
end
