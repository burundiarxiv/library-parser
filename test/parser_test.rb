require 'minitest/autorun'
require 'pry'
require_relative '../lib/parser'

class ParserTest < Minitest::Test
  def test_extract_content_chap_2_1
    test_extract_chapter('chap-2-1')
  end

  def test_extract_content_chap_2_2
    test_extract_chapter('chap-2-2')
  end

  private

  def test_extract_chapter(chapter)
    parser = Parser.new("data/#{chapter}.txt")
    matches = parser.parse
    matches.each do |match|
      assert(match[1].count == 6, match[0])
    end
  end
end

