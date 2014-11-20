#!/usr/bin/ruby

require 'optparse'
require 'csv'
require_relative 'freqcount'

options = {
  :load => 'words.db',
  :pmax => 1,
  :pmin => 1e-1,
  :output => STDOUT,
  :debug => false}

OptionParser.new do |opts|
  opts.banner = "Usage: lorems [-l|--load words.db] [--pmin min] [--pmax max] [-d|--debug]"
  opts.on("-l", "--load [INPUT]","dump (ruby marshal, default words.db) input file") do |file|
    options[:load]=file
  end
  opts.on("--pmin [MIN]","prob lower bound") do |pmin|
    options[:pmin]=pmin.to_f
  end
  opts.on("--pmax [MAX]","prob upper bound") do |pmax|
    options[:pmax]=pmax.to_f
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
fc.lorems(options[:pmin],options[:pmax]) do |word,prob|
  csv << [word,prob]
end
csv.close
