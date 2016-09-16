# extracts info from PDF papers

require "pdf-reader"

class Wisdom

  attr_reader :title, :authors, :abstract, :filename
  
  def initialize filename
    @filename = filename
  end

  def get_reader
    PDF::Reader.new(@filename)
  rescue => exception
    exception.message
  end
  
  def process
    reader = get_reader
    reader.class == PDF::Reader ? get_info(reader.pages[0]) : @title = "PDF_Error: #{reader}"
  end

  def get_info page0
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
      abstract = text[/(?<=Abstract).*/m].gsub(/ {2,99}/, " ").strip
      if abstract[/.*(?<=Introduction)/m]
        abstract = abstract[/.*(?<=Introduction)/m].sub(/1 + Introduction/, "").gsub(/ {2,99}/, " ").strip
      end
    else
      abstract = text.gsub(/\n+/, "\n").gsub(/ +/, " ").strip
    end
    abstract
  end
  
end

