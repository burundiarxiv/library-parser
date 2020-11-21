require 'pry'
require 'json'
require_relative 'chapters'
require_relative 'regex_extractor'

class Parser
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
        authors: authors.split(';').map { |author| author.strip.gsub(',', '') },
        title: title,
        edition: edition,
        misc: misc,
        year: year,
        pages: pages,
        tags: CHAPTERS[@chap_number.to_sym].split(';')
      }
    end
  end

  def write(destination)
    File.open(destination, 'w') { |file| file.write(export.to_json) }
  end

  private

  def clean
    map = { '“' => '"', '”' => '"', '’' => "'", '‘' => "'" }
    re = Regexp.new(map.keys.map { |x| Regexp.escape(x) }.join('|'))
    @content.gsub!(re, map)
  end

  def extract(line)
    line.scan(REGEX_EXTRACTOR).flatten
  end
end
