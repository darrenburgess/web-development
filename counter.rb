require "socket"
require "pry"

server = TCPServer.new "localhost", 3003

def parse_request(request)
  http_method, path_and_params, http = request.split(' ')
  path, params = path_and_params.split('?')

  params = params.split("&").each_with_object({}) do |pair, hash|
    key, value = pair.split('=')
    hash[key] = value
  end unless params == nil

  [http_method, path, params]
end

loop do
  client = server.accept
  request_line = client.gets
  puts request_line

  http_method, path, params = parse_request(request_line) 

  client.puts "HTTP/1.0 200 OK"
  client.puts "Content-Type: text/html"
  client.puts
  client.puts "<html>"
  client.puts "<body>"

  client.puts "<pre>"
  client.puts request_line
  client.puts http_method
  client.puts path
  client.puts params
  client.puts "</pre>"

  client.puts "<h1>Counter</h1>"

  number = params["number"].to_i
  client.puts "<p> The current number is #{number}.</p>"

  client.puts "</body>"
  client.puts "</html>"
  client.close
end
