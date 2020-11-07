require 'minitest/autorun'
require 'pry'
require_relative '../lib/parser'

class ParserTest < Minitest::Test
  def test_extract_content
    parser = Parser.new('data/chap-2-1.txt')
    matches = parser.parse
    matches.each do |match|
      assert(match[1].count == 6, match[0])
    end
  end
end

