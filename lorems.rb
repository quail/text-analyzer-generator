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

sum0=0.0
sum1=0.0
info=0.0
bits=0.0

while pmin <= pmax/2.0 do
  sum0=0.0
  fc.lorems(pmax/2.0,pmax) do |word,prob|
    bits =-prob*Math.log2(prob)
    info = info + bits
    sum0 = sum0 + prob
    csv << [word,prob,sum0+sum1,bits,info]
  end
  sum1=sum1+sum0
  pmax = pmax/2.0
end
if pmin < pmax then
  sum0=0.0
  fc.lorems(pmin,pmax) do |word,prob|
    bits =-prob*Math.log2(prob)
    info = info + bits
    sum0 = sum0 + prob
    csv << [word,prob,sum0+sum1,bits,info]
  end
  sum1=sum1+sum0
end
csv.close
