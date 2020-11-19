require_relative 'lib/parser'
require_relative 'lib/chapters'

CHAPTERS.keys.each do |chapter|
  parser = Parser.new("data/#{chapter}.txt")
  parser.run
end

library = []
Dir.glob('export/chap-*.json') do |f|
  file = File.read(f)
  library.concat JSON.parse(file)
end

File.open('export/library.json', 'w') { |file| file.write(library.to_json) }
