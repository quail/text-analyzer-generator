#!/usr/bin/ruby

require 'optparse'
require 'csv'

$options = {
  :a => nil,
  :b => nil,
  :rel => nil,
  :abs => nil,
  :debug => false}

OptionParser.new do |opts|
  opts.banner = "Usage: csv_close -a <file> -b  <file> -rel <relative_error> -abs <absolute_error> [-d|--debug]"
  opts.on("-a [INPUT]","input file a") do |file|
    $options[:a]=file
  end
  opts.on("-b [INPUT]","input file b") do |file|
    $options[:b]=file
  end
  opts.on("--rel","--rel [EPSILON]","relative error tolerance") do |eps|
    $options[:rel]=(eps == "nil") ? nil : eps.to_f
  end
  opts.on("--abs","--abs [EPSILON]","absolute error tolerance") do |eps|
    $options[:abs]=(eps == "nil") ? nil : eps.to_f
  end
  opts.on("-d","--debug","debugging") do |debug|
    $options[:debug]=true
  end
end.parse!

def cmprow(a,b)
  if :eof == a or :eof == b then
    if :eof != a then
      raise "file #{$options[:a]} is longer than #{$row-1} rows."
    end
    if :eof != b then
      raise "file #{$options[:b]} is longer than #{$row-1} rows."
    end
  else
    $column=0
    a.zip(b).each do |adata,bdata|
      $column=$column+1
      cmpdata(adata,bdata)
    end
  end
end

def cmpdata(a,b)
  anumeric=a.is_a? Numeric
  bnumeric=b.is_a? Numeric
  if anumeric != bnumeric then
    raise "row #{$row} column #{$column} numeric/non-numeric type differs"
  end
  if not anumeric  then
    if a != b then
      raise "row #{line} column #{column} non-numeric data differs"
    end
  else
    cmpabs(a,b)
    cmprel(a,b)
  end
end

def cmpabs(a,b)
  if not $options[:abs].nil? then
    eps=(a-b).to_f
    if eps.abs > $options[:abs] then
      raise "row #{$row} column #{$column} absolute error #{a}-#{b}=#{eps} too large."
    end
  end
end

def cmprel(a,b)
  if not $options[:rel].nil? then
    if a != 0 or b != 0 then
      eps=(a-b)/[a.abs,b.abs].max.to_f
      if eps.abs > $options[:rel] then
        raise "row #{$row} column #{$column} relative error (#{a}-#{b})/max abs=#{eps} too large."
        end
    end
  end
end

a = CSV.open($options[:a], "r", converters: :numeric).each
b = CSV.open($options[:b], "r", converters: :numeric).each

$row = 0
$column = 0

begin
  loop do
    $row = $row + 1
    arow = a.next rescue :eof
    brow = b.next rescue :eof
    cmprow(arow,brow)
    if arow == :eof or brow == :eof then
      break
    end
  end
rescue Exception => e
  print "#{e.message}\n"
  exit 1
end

exit 0

