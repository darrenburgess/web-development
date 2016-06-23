require "socket"
require "pry"

server = TCPServer.new "localhost", 3003

loop do
  client = server.accept
  request_line = client.gets
  puts request_line

  http_method, path, params = parse_params(request_line) 

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



  client.puts "</body>"
  client.puts "</html>"
  client.close
end
