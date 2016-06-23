require "socket"
require "pry"

server = TCPServer.new "localhost", 3003

def parse_params(request)
  http_method, path_and_params, http = request.split(' ')
  path, params = path_and_params.split('?')

  if params
    params = params.split("&").each_with_object({}) do |pair, hash|
      key, value = pair.split('=')
      hash[key] = value
    end
  end

  [http_method, path, params]
end

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

  client.puts "<h1>Rolls</h1>"
  if params
    rolls = params["rolls"].to_i
    sides = params["sides"].to_i

    rolls.to_i.times do |roll|
      roll += 1
      client.puts "<p>"
      client.puts "roll #{roll}: #{rand(sides.to_i) + 1} on #{sides} sided die"
      client.puts "</p>"
    end
  end

  client.puts "</body>"
  client.puts "</html>"
  client.close
end
