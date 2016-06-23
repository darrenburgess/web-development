require "socket"
require "pry"

server = TCPServer.new "localhost", 3003

def parse_params(request)
  params = /\?.+ /.match(request).to_s.chop
  params.slice! 0
  array = params.split("&")
  Hash[ array.map! { |param| param.split("=") } ]
end

def roll_dice(client, rolls, sides)
  rolls.to_i.times do |roll|
    roll += 1
    client.puts "roll #{roll}: #{rand(sides.to_i) + 1} on #{sides} sided die"
  end
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
  roll_dice(client, params["rolls"], params["sides"])
  client.close
end
