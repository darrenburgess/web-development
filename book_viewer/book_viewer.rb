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

def matching_files
  files = Dir.entries("data/").select { |file| !!(file =~ /^chp/) }
  result = files.select do |file|
    content = File.read("data/#{file}")
    content.include? @query if @query
  end
  result
end

def matching_paragraphs
  result = {}

  matching_files.each do |file|
    paragraphs_result = []
    number = file.delete("^0-9")
    paragraphs = File.read("data/chp#{number}.txt").split("\n\n")
    paragraphs.select do |paragraph|
      paragraphs_result << paragraph if paragraph.include? @query
    end
    result[file] = paragraphs_result unless paragraphs_result.empty?
  end

  result
end

get "/search" do
  @query = params["query"] unless params["query"].nil?
  @file_results = matching_paragraphs
  erb :search
end

not_found do
  redirect "/"
end
