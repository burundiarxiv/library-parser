require_relative 'lib/parser.rb'

chapter = 'chap-2-1'
parser = Parser.new("data/#{chapter}.txt")
parser.run
