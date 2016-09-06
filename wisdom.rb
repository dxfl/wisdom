
require "pdf-reader"

class Wisdom

  attr_reader :title, :authors
    
  def initialize filename
    @filename = filename
  end

  def process
    reader = PDF::Reader.new(@filename)
    get_info reader.pages[0]
  end

  def get_info page0
    info = page0.text[0..300].split("\n")
    @title = info[0].lstrip
    @authors = info[5].lstrip.gsub(/ {2,99}/, ", ")
  end
  
end

#  w = Wisdom.new("mikolov.pdf")
#  w.process
#  puts w.title
#  puts w.authors

