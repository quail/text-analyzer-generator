#!/usr/bin/ruby

require 'optparse'
require 'csv'
require_relative 'freqcount'

options = {
  :load => 'words.db',
  :count => 10,
  :output => STDOUT,
  :debug => false}

OptionParser.new do |opts|
  opts.banner = "Usage: lorem [-l|--load words.db] [-c|--count 10] [-d|--debug]"
  opts.on("-l", "--load [INPUT]","dump (ruby marshal, default words.db) input file") do |file|
    options[:load]=file
  end
  opts.on("-c","--count [COUNT]","number of words to produce") do |count|
    options[:count]=count.to_i
  end
  opts.on("-o","--out [FILE]","output") do |file|
    if file != "/dev/stdout" then
      options[:output]=File.open(file,"w")
    else
      options[:output]=STDOUT
    end
  end
  opts.on("-d","--debug","debug") do |debug|
    options[:debug]=debug
  end
end.parse!

if options[:debug] then
  print "options: #{options}\n"
end

fc = FreqCount.new(1)

if options[:load].nil? then
  print "load (dump) file not specified.\n"
  exit
end

fc.load(options[:load])

csv = CSV.new(options[:output])
options[:count].to_i.times { csv<<fc.lorem }
csv.close
