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

  def test_export_to_json
    chapter = 'chap-2-1'
    parser = Parser.new("data/#{chapter}.txt")
    parser.parse
    json_results = parser.export
    assert_equal(expected_json, json_results.first)
  end

  private

  def test_extract_chapter(chapter)
    parser = Parser.new("data/#{chapter}.txt")
    matches = parser.parse
    matches.each do |match|
      assert(match[1].count == 6, match[0])
    end
  end

  def expected_json
    {
      "line": "Botte, Roger; Muel-Dreyfus, Francine; Le Pape, Marc; Vidal, Claudine, \"Les relations personnelles de subordination dans les sociétés interlacustres de l'Afrique centrale: Problèmes de méthode\", Cahiers d'études africaines, 9-35, 1969, pp. 350-401.",
      "authors": [
        'Botte, Roger',
        'Muel-Dreyfus, Francine',
        'Le Pape, Marc',
        'Vidal, Claudine'
      ],
      "title": "Les relations personnelles de subordination dans les sociétés interlacustres de l'Afrique centrale: Problèmes de méthode",
      "edition": "Cahiers d'études africaines",
      "misc": '9-35, ',
      "year": '1969',
      "pages": 'pp. 350-401',
      "tags": %w[
        HISTOIRE
        TÉMOIGNAGE
        Historiographie
        Méthodes
      ]
    }
  end
end
