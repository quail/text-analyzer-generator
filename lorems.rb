#!/usr/bin/ruby

require 'optparse'
require 'csv'
require_relative 'freqcount'

options = {
  :load => 'words.db',
  :pmax => 1,
  :pmin => Float::EPSILON,
  :csv => STDOUT,
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
  opts.on("-c","--csv [FILE]","word,prob csv") do |file|
    if file != "/dev/stdout" then
      options[:csv]=File.open(file,"w")
    else
      options[:csv]=STDOUT
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

csv = CSV.new(options[:csv])
pmin=options[:pmin]
pmax=options[:pmax]
if pmax == 1.0 then
  pmax = 2.0
end

sum=0.0

while pmin <= pmax/2.0 do
  fc.lorems(pmax/2.0,pmax) do |word,prob|
    sum = sum + prob
    csv << [word,prob,sum]
  end
  pmax = pmax/2.0
end
if pmin < pmax then
  fc.lorems(pmin,pmax) do |word,prob|
    sum = sum + prob
    csv << [word,prob,sum]
  end
end
csv.close
