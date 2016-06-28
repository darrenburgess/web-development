require "sinatra"
require "sinatra/reloader" if development?
require "tilt/erubis"

before do
  @contents = File.readlines("data/toc.txt")
end

helpers do
  def in_paragraphs(text)
    text.split("\n\n").each_with_index.map { |line, index| "<p id='#{index}'>#{line}</p>"}.join
  end

  def highlight(text, query)
    text.gsub query, "<strong>#{query}</strong>"
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

get "/search" do
  @query = params["query"] unless params["query"].nil?
  @file_results = matching_paragraphs
  erb :search
end

not_found do
  redirect "/"
end

def file_title(file_name)
  index = (file_name.delete("^0-9").to_i) - 1
  @contents[index]
end

def matching_paragraphs
  result = {}

  matching_files.each do |file|
    paragraphs_result = {}
    number = file.delete("^0-9")
    paragraphs = File.read("data/#{file}").split("\n\n")

    paragraphs.select.with_index do |paragraph, index|
      paragraphs_result[index] = highlight(paragraph, @query) if paragraph.include? @query
    end

    result[file] = paragraphs_result unless paragraphs_result.empty?
  end

  result
end

def matching_files
  files = Dir.entries("data/").select { |file| file.include? 'chp' }  

  result = files.select do |file|
    content = File.read("data/#{file}")
    content.include? @query if @query
  end
  
  result
end
