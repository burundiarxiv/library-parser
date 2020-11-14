require 'pry'
require 'json'

class Parser
  REGEX_EXTRACTOR = Regexp.new(%r{(^[\w+'éÉçë,.;—() -]+),\s"([\wéêèïçàÉ'-:? XXVI,\[\]()]*)",\s([\s\w+'éèàçÉ.()\[\]\/:-]+),\s(.*)\s?(\d{4}[-\/]?\d*),\s(p+.\s\d+-\d+|\d+\sp.)})
  TAGS =
    {
      'chap-2-1-1': 'HISTOIRE;TÉMOIGNAGE;Historiographie;Méthodes',
      'chap-2-1-2': 'HISTOIRE;TÉMOIGNAGE;Longues durées',
      'chap-2-1-3': 'HISTOIRE;TÉMOIGNAGE;Préhistoire; Archéologie'
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
    write("export/#{@chap_number}.json")
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

  def write(destination)
    File.open(destination, 'w') { |file| file.write(export.to_json) }
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
end
