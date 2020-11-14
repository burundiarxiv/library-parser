require 'minitest/autorun'
require 'pry'
require 'json'
require_relative '../lib/parser'

class ParserTest < Minitest::Test
  def test_extract_content_chap_2_1_1
    test_extract_chapter('chap-2-1-1')
  end

  def test_extract_content_chap_2_1_2
    test_extract_chapter('chap-2-1-2')
  end

  def test_extract_content_chap_2_1_3
    test_extract_chapter('chap-2-1-3')
  end

  def test_export_to_json
    parser = parse_chapter('chap-2-1-1')
    json_results = parser.export
    assert_equal(expected_json, json_results.first)
  end

  def test_write_json_file
    parser = parse_chapter('chap-2-1-1')
    exported_file = 'test/fixtures/chap-2-1-1.json'
    parser.write(exported_file)

    file = File.read(exported_file)
    data_hash = JSON.parse(file)
    assert_equal(expected_json.map { |k, v| [k.to_s, v]}.to_h, data_hash.first)
  end

  private

  def test_extract_chapter(chapter)
    parser = Parser.new("data/#{chapter}.txt")
    matches = parser.parse
    matches.each do |match|
      assert(match[1].count == 6, match[0])
    end
  end

  def parse_chapter(chapter)
    parser = Parser.new("data/#{chapter}.txt")
    parser.parse
    parser
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
