class Parser
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

  # def lines
  #   @content.split("\n")
  # end

  def parse
    regex = Regexp.new(/(^[\w+'é,; -]+),\s"([\wéèà'-: XXVI,]*)",\s([\s\w+'éè()]+),\s(.*)\s(\d{4}-?\d?),\s(p+.\s\d+-\d+)/)
    binding.pry
    @matches = @content.scan(regex) || []
    binding.pry
    puts @matches
    @matches
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

# parser = Parser.new
# parser.parse
# puts parser.content
# pp parser.run
