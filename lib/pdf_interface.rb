# extracts info from PDF papers

require "pdf-reader"

class PDFInterface

  attr_reader :title, :authors, :abstract, :filename, :body
  
  def initialize filename
    @filename = filename
  end

  def with_error_handling
    yield
  rescue => exception
    "PDF_Error: #{exception.message}"
  end
  
  def get_reader
    PDF::Reader.new(@filename)
  end
  
  def process
    reader = with_error_handling{ get_reader }
    reader.class == PDF::Reader ? get_info(reader.pages) : @title = reader
  end

  def get_info pages
    page0 = pages[0]
    @title = with_error_handling{ get_title(page0) }
    @authors = "unknown"
    @abstract = with_error_handling{ get_abstract page0.text[0..3000] }
    @body = with_error_handling{ get_body(pages) }
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

  def get_body pages
    pages.map{ |pag| pag.text }.reduce{ |sum, val| sum + val }
  end
end

