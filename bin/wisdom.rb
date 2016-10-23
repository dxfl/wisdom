#!/usr/bin/env ruby
# process arxiv downloaded pdf files

require 'logger'
require 'optparse'
require_relative '../lib/wisdom'


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

  #database name
  options[:database] = "arxiv" #default name
  opts.on("-b", "--database DATABASE", 'indicate mongo database name') do |db|
    options[:database] = db
  end
  
  #collection name
  options[:collection] = "arxiv" #default name
  opts.on("-c", "--collection COLLECTION", 'indicate mongo collection name') do |coll|
    options[:collection] = coll
  end
end

option_parse.parse!

#LOG = Logger.new($stderr)
#LOG.level = Logger.const_get(ENV.fetch("LOG_LEVEL", "INFO"))

w = Wisdom.new(options)
w.init

puts ">> Exiting wisdom at #{Time.now}"

