#!/usr/bin/ruby

require 'optparse'
require 'csv'
require_relative 'freqcount'

options = {
  :load => nil,
  :csv => 'words.csv',
  :save => 'words.db',
  :weight => 1,
  :length => 2,
  :debug => false}

OptionParser.new do |opts|
  opts.banner = "Usage: testfreqcount [--load nil] [-c|--csv words.csv] [-s|--save weights.db] [-l|--length 2] [-w|--weight 1] [-d|--debug]"
  opts.on(nil, "--load [INPUT]","dump (ruby marshal) input file") do |file|
    options[:load]=file
  end
  opts.on("-c","--csv [INPUT]","csv (name,weight=1) input file") do |file|
    options[:csv]=file
  end
  opts.on("-s","--save [OUTPUT]","dump (ruby marshal) output file") do |file|
    options[:save]=file
  end
  opts.on("-l","--length [CHAIN]","chain length (>=1)") do |length|
    options[:length]=length.to_i
  end
  opts.on("-w","--weight [WEIGHT]","overall weight (>=1)") do |weight|
    options[:weight]=weight.to_f
  end
  opts.on("-d","--debug","debugging") do |debug|
    options[:debug]=true
  end
end.parse!

if options[:debug] then
  print "options: #{options}\n"
end

fc = FreqCount.new(options[:length])

if not options[:load].nil? then
  if options[:debug] then
    print "loading from #{options[:load]}\n"
  end
  fc.load(options[:load])
end

count=0
CSV.foreach(options[:csv]) do |row|
  if options[:debug] then
    print "row #{count}: #{row}\n"
  end
  if row.length > 1 then
    fc.add_password(row[0]||"",row[1].to_f*options[:weight])
  else
    fc.add_password(row[0]||"",options[:weight])
  end
  count=count+1
end

if options[:debug] then
  print "freqcount: #{fc}\n";
end

if options[:debug] then
  print "saving to: #{options[:save]}\n";
end

fc.save(options[:save])
