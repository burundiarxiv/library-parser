require 'minitest/autorun'
require 'pry'
require_relative '../lib/parser'

class ParserTest < Minitest::Test
  def test_extract_content
    parser = Parser.new('test/fixtures/sample-2.txt')
    matches = parser.parse
    matches.each do |match|
      puts match.count
    #   # assert_equal 6, match.count
    end
  end
end
# describe Parser do
#   describe 'extract content' do
#     it 'matches 6 categories for each line' do
#       parser = Parser.new('sample-1.txt')
#       parser.clean
#       matches = parser.parse
#       binding.pry
#     end
#   end
# end
