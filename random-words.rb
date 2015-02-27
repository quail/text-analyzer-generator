#!/usr/bin/ruby
require 'optparse'
require 'csv'

options = {
  :in => 'words.csv',
  :out => '/dev/stdout',
  :count => 100,
  :debug => false}

OptionParser.new do |opts|
  opts.banner = "Usage: random-words [-i|--in words.csv] [-o|--out /dev/stdout] [-c|--count 100] [-d|--debug]"
  opts.on("--in [INPUT]","word,freq csv input file (from tally)") do |file|
    options[:in]=file
  end
  opts.on("--out [OUTPUT]","prob,word output file") do |file|
    options[:out]=file
  end
  opts.on("-c","--count [NUMBER]","number of words in output") do |number|
    if number == "infinity" then
      options[:count]=:infinity
    else
      options[:count]=number.to_i
    end
  end
  opts.on("-d","--debug","debugging") do |debug|
    options[:debug]=true
  end
end.parse!

word2weight = Hash.new()
totalweight = 0
CSV.foreach(options[:in]) do |row|
  word=row[0]
  weight=row[1].to_f  
  if weight > 0
    word2weight[word] = (word2weight[word]||0.0)+weight
    totalweight = totalweight + weight
  end
end

words = Array.new()
probs = Array.new()
cumprobs = Array.new()

i = 0

word2weight.each do |word,weight|
  words[i] = word
  probs[i] = weight/totalweight
  cumprobs[i] = ((i > 0) ? cumprobs[i-1] : 0.0) + probs[i]
  if cumprobs[i] > 1.0 then
    cumprobs[i]=1.0
  end
  i = i + 1
end
cumprobs[cumprobs.length-1]=1

fd = File.open(options[:out],'w')

random = Random.new()
count = 0
while (options[:count] == :infinity or count < options[:count]) do
  p = random.rand
  i = (0..(cumprobs.length-1)).bsearch { |k| cumprobs[k] >= p }
  fd.write("#{probs[i]},#{words[i]}\n")
  count = count + 1
end
