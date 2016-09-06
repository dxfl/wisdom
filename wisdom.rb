
require "pdf-reader"

class Wisdom

  attr_reader :title, :authors, :abstract
  
  def initialize filename
    @filename = filename
  end

  def process
    reader = PDF::Reader.new(@filename)
    get_info reader.pages[0]
  end

  def get_info page0
    info = page0.text[0..500].split("\n") # the info use to be in the first
    @title = info[0].lstrip #title is first sentence
    @authors = info[5].lstrip.gsub(/ {2,99}/, ", ") # authors the 5th item
    @abstract = page0.text[0..3000][/(?<=Abstract).*/m][/.*(?<=Introduction)/m].sub(/1 + Introduction/, "").gsub(/ {2,99}/, " ").lstrip
  end
  
end

#  w = Wisdom.new("mikolov.pdf")
#  w.process
#  puts w.title
#  puts w.authors

