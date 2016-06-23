require "socket"
require "pry"

server = TCPServer.new "localhost", 3003

def parse_params(request)
  params = /\?.+ /.match(request).to_s.chop
  params.slice! 0
  array = params.split("&")
  Hash[ array.map! { |param| param.split("=") } ]
end

loop do
  client = server.accept
  request_line = client.gets
  puts request_line

  http_method = request_line.split.first
  path = /\/.+\?/.match(request_line).to_s.chop
  params = parse_params(request_line)

  client.puts request_line
  client.puts http_method
  client.puts path
  client.puts params
  client.puts rand(6) + 1
  client.close
end

# GET /?rolls=2&sides=6 HTTP/1.1

