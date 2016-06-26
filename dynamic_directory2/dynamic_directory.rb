require 'sinatra'
require 'sinatra/reloader'
require 'tilt/erubis'
require 'pry'

get '/' do
  @title = "File Directory"
  @files = Dir.glob('public/*.txt').map { |file| File.basename(file) }
  if @params["sort"] == "descending"
    @files.reverse!
  else
    @files.sort
  end

  erb :home
end

get "/file" do
  @file_name = @params["file"]
  @content = File.read(@file_name)
  erb :file
end
