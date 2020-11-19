require_relative 'lib/parser.rb'
require_relative 'lib/tags.rb'

TAGS.keys.each do |chapter|
  parser = Parser.new("data/#{chapter}.txt")
  parser.run
end

library = []
Dir.glob('export/chap-*.json') do |f|
  file = File.read(f)
  library.concat JSON.parse(file)
end

File.open('export/library.json', 'w') { |file| file.write(library.to_json) }
