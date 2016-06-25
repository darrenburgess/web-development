require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"

get "/" do
  @title = "The Adventures of Sherlock Holmes"
  @contents = File.read("data/toc.txt").split(/\n/)
  erb :home
end

get "/chapter/1" do
  @title = "Chapter 1"
  @chapter = File.readlines("data/chp1.txt")
  @contents = File.readlines("data/toc.txt")

  erb :chapter
end
