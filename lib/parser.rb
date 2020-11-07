class Parser
  REGEX_EXTRACTOR = Regexp.new(/(^[\w+'éÉ,.; -]+),\s"([\wéèçà'-:? XXVI,]*)",\s([\s\w+'éèÉ()\/:]+),\s(.*)\s(\d{4}-?\d?),\s(p+.\s\d+-\d+|\d+\sp.)/)

  def initialize(file_path = 'sample-1.txt')
    @content = File.read(file_path)
    clean
    @lines = @content.split("\n")
  end

  def clean
    map = {'“' => '"', '”' => '"', "’" => "'" }
    re = Regexp.new(map.keys.map { |x| Regexp.escape(x) }.join('|'))
    @content.gsub!(re, map)
  end

  def extract(line)
    line.scan(REGEX_EXTRACTOR).flatten
  end

  def parse
    @matches = @lines.map { |line| [line, extract(line)] }
  end

  def export
   @matches.map do |match|
      authors, title, edition, misc, year, pages = match
      {
        authors: authors,
        title: title,
        edition: edition,
        misc: misc,
        year: year,
        pages: pages
      }
    end
  end

  def run
    clean
    parse
    export
  end
end
