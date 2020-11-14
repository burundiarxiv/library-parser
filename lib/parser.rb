require 'pry'
require 'yaml'

class Parser
  REGEX_EXTRACTOR = Regexp.new(%r{(^[\w+'éÉçë,.;() -]+),\s"([\wéèçà'-:? XXVI,]*)",\s([\s\w+'éèÉ()\[\]/:-]+),\s(.*)\s?(\d{4}[-/]?\d*),\s(p+.\s\d+-\d+|\d+\sp.)})
  TAGS =
    {
      'chap-2-1': 'HISTOIRE;TÉMOIGNAGE;Historiographie;Méthodes',
      'chap-2-2': 'HISTOIRE;TÉMOIGNAGE;Longues durées'
    }.freeze

  def initialize(file_path)
    @content = File.read(file_path)
    @chap_number = File.basename(file_path, '.txt')
    clean
    @lines = @content.split("\n")
  end

  def parse
    @matches = @lines.map { |line| [line, extract(line)] }
  end

  def run
    parse
    write
  end

  def export
    @matches.map do |match|
      line = match[0]
      authors, title, edition, misc, year, pages = match[1]
      {
        line: line,
        authors: authors.split(';').map(&:strip),
        title: title,
        edition: edition,
        misc: misc,
        year: year,
        pages: pages,
        tags: TAGS[@chap_number.to_sym].split(';')
      }
    end
  end

  private

  def clean
    map = { '“' => '"', '”' => '"', '’' => "'" }
    re = Regexp.new(map.keys.map { |x| Regexp.escape(x) }.join('|'))
    @content.gsub!(re, map)
  end

  def extract(line)
    line.scan(REGEX_EXTRACTOR).flatten
  end

  def write
    File.open("export/#{@chap_number}.yml", 'w') { |file| file.write(to_yaml) }
  end
end
