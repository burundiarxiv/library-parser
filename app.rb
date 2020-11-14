require_relative 'lib/parser.rb'

Parser::TAGS.keys.each do |chapter|
  parser = Parser.new("data/#{chapter}.txt")
  parser.run
end
