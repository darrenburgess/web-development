require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"
require "pry"

before do
  @contents = File.readlines("data/toc.txt")
end

helpers do
  def in_paragraphs(text)
    text.split("\n\n").each_with_index.map { |line, index| "<p id='#{index}'>#{line}</p>"}.join
  end
end

get "/" do
  @title = "The Adventures of Sherlock Holmes"
  erb :home
end

get "/chapters/:number" do
  number = params['number'].to_i
  text = File.read("data/chp#{number}.txt")
  @chapter = in_paragraphs(text)
  chapter_name = @contents[number - 1]
  @title = "Chapter #{number} | #{ chapter_name }"
  erb :chapter
end

def return_files(query)
  files = Dir.entries("data/").select { |file| !!(file =~ /^chp/) }
  result = files.select do |file|
    content = File.read("data/#{file}")
    content.include? query if query
  end
  result
end

def return_paragraphs
  # initialize result hash
  # iterate array of found files
  # construct array of paragraphs for current file
  # initialize para array
  # iterate array of paragraphs
  # push paragraph to result array if match to query string
  # push array of matching paragraphs and title to result hash
  # return result hash
end

get "/search" do
  @query = params["query"] unless params["query"].empty? 
  @file_results = return_files(@query)
  erb :search
end

not_found do
  redirect "/"
end
