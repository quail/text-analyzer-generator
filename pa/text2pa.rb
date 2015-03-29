#/usr/bin/ruby
require_relative 'smallautomata'


$debug = true
$depth = 2

#
# fc - frequency of characters f[char]->count in ab.txt
# 
fc = Hash.new()

count=0
File.open("ab.txt").each do |line|
  line.strip.each_char { |c| fc[c] = (fc[c]||0) + 1 }
  count=count+1
end

if count > 0 then
  fc[:start]=count
  fc[:end]=count
end

#
# wc - list of [c,w], in decreasing order
#
fc_norm = 0
fc.values.each { |count| fc_norm = fc_norm + count }
fc_norm = 1.0/fc_norm
$wc = fc.map{ |p| [p[0],p[1]*fc_norm] }.sort { |a,b| b[1] <=> a[1] }

if $debug then
  puts "character weights: "
  puts $wc
end

#
# invert the wc map of index to characters (and weights)
#
#    wc[index]->[character,weight] iff  ic[fcharacter]->index
#
$ic = Hash.new
$wc.each_with_index { |pair,index| $ic[pair[0]]=index }

if $debug then
  print "index map: "
  puts $ic
end
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$wd = Hash.new()
$at = Array.new($depth,:start)

def process(s)
  wk=$wd;
  $at.shift
  $at.each do |sk|
    if wk[sk].nil? then
      wk[sk]=Hash.new()
    end
    wk=wk[sk]
  end
  wk[s]=(wk[s]||0)+1
  $at << s
end

File.open("ab.txt").each do |line|
  $at = Array.new($depth,:start)
  line.strip.each_char { |c| process(c) }
  process(:end)
end

if $debug then
  print "chained weights (depth=#{$depth}): "
  puts $wd
end

fd = File.open("abtest.txt","w")
$wd.each do |key, value|
	fd.write "#{key}:\t{value}\n"
end
fd.close
