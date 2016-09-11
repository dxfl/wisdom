
require "pdf-reader"

class Wisdom

  attr_reader :title, :authors, :abstract, :filename
  
  def initialize filename
    @filename = filename
  end

  def process
    reader = PDF::Reader.new(@filename)
    get_info reader.pages[0]
  end

  def get_info page0
    #info = page0.text[0..500].split(/\n+/).map(&:strip) # the info use to be in the first
    @title = get_title page0
    @authors = "unknown"
    @abstract = get_abstract page0.text[0..3000]
  end

  def get_title page0
    page0.text[0..500].gsub(/\n+/, "\n").gsub(/ +/, " ").strip
  rescue
    page0.text[0..200].gsub(/\n+/, "\n").gsub(/ +/, " ").strip
  end
  
  def get_abstract text
    if text[/(?<=Abstract).*/m]
      abstract = text[/(?<=Abstract).*/m]
      if abstract[/.*(?<=Introduction)/m]
        abstract = abstract[/.*(?<=Introduction)/m].sub(/1 + Introduction/, "").gsub(/ {2,99}/, " ").strip
      end
    else
      abstract = text.gsub(/\n+/, "\n").gsub(/ +/, " ").strip
    end
  end

  
end


# w = Wisdom.new("mikolov.pdf")
# w.process
# puts w.title
# puts w.authors
# puts w.abstract
