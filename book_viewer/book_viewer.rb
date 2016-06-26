require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"
require "pry"

get "/" do
  @title = "The Adventures of Sherlock Holmes"
  @contents = File.read("data/toc.txt").split(/\n/)
  erb :home
end

get "/chapters/:number" do
  number = params['number'].to_i
  @chapter = File.readlines("data/chp#{number}.txt")
  @contents = File.readlines("data/toc.txt")
  chapter_name = @contents[number - 1]
  @title = "Chapter #{number} | #{ chapter_name }"
  erb :chapter
end

get "/show/:name" do
  params[:name]
end
