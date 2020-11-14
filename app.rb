require_relative 'lib/parser.rb'

['chap-2-1', 'chap-2-2'].each do |chapter|
  parser = Parser.new("data/#{chapter}.txt")
  parser.run
end
