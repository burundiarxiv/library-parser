require 'pry'
require 'yaml'

class Parser
  REGEX_EXTRACTOR = Regexp.new(/(^[\w+'éÉçë,.;() -]+),\s"([\wéèçà'-:? XXVI,]*)",\s([\s\w+'éèÉ()\[\]\/:-]+),\s(.*)\s?(\d{4}[-\/]?\d*),\s(p+.\s\d+-\d+|\d+\sp.)/)

  def initialize(file_path)
    @file_path = file_path
    @content = File.read(file_path)
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

  private

  def clean
    map = {'“' => '"', '”' => '"', "’" => "'" }
    re = Regexp.new(map.keys.map { |x| Regexp.escape(x) }.join('|'))
    @content.gsub!(re, map)
  end

  def extract(line)
    line.scan(REGEX_EXTRACTOR).flatten
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
        pages: pages
      }
    end
  end

  def to_yaml
    YAML.dump(export)
  end

  def write
    filename = File.basename(@file_path, '.txt')
    File.open("export/#{filename}.yml", 'w') { |file| file.write(to_yaml) }
  end
end

parser = Parser.new('data/chap-2-1.txt')
parser.run
