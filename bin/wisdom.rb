#!/usr/bin/env ruby
# process arxiv downloaded pdf files

require_relative '../lib/pdf_interface'
require_relative '../lib/mongo_interface'
require 'logger'
require 'optparse'

options = {}
option_parse = OptionParser.new do |opts|
  executable_name = File.basename($PROGRAM_NAME)
  opts.banner = <<-EOF
Extract papers from downloaded arxiv pdfs and send them to mongo

Usage: #{executable_name} [options]

EOF

  #directory
  opts.on("-d", "--directory DIRECTORY", 'indicate main pdf directory') do |dir|
    options[:directory] = dir
  end

  #collection name
  options[:collection] = "arxiv" #default name
  opts.on("-c", "--collection COLLECTION", 'indicate mongo collection name') do |coll|
    options[:collection] = coll
  end
end

option_parse.parse!

MAIN_DIR = options[:directory]
COLLECTION_NAME = options[:collection]

LOG = Logger.new($stderr)
LOG.level = Logger.const_get(ENV.fetch("LOG_LEVEL", "INFO"))

def delete_dots list
  list.delete(".")
  list.delete("..")
  list
end

def get_directories directory
  dir_list = delete_dots Dir.entries(directory)
  #dir_list.select{ |dir| Dir.exist?(dir)}
end

def get_files folder
  delete_dots Dir.entries(folder)
end

def check_posts posts
  posts_size= posts.map{ |_, value| value.size }.reduce(:+)
  if posts_size >= MongoInterface::MaxBSONSize
    max_size = MongoInterface::MaxBSONSize - post_size + posts[:body].size - 1
    posts[:body] = posts[:body][0..max_size]
  end
  posts
rescue => exception
  posts[:body] = "PDF_Error: #{exception.message}"
  posts
end

def process
  mongo = MongoInterface.new("arxiv", COLLECTION_NAME)
  pdf_directories = get_directories MAIN_DIR
  pdf_directories.each do |dir|
    path = MAIN_DIR + dir + "/"
    pdf_files = get_files path
    pdf_files.each do |file|
      pdf = PDFInterface.new(path + file)
      pdf.process
      posts = [{filename: file, #pdf.filename includes path
                title: pdf.title,
                authors: pdf.authors,
                abstract: pdf.abstract,
                body: pdf.body}]
      check_posts posts
      mongo.save posts
      LOG.info "Processed paper: #{pdf.filename}"
    end
  end
end


process



