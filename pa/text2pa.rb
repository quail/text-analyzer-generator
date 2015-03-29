#/usr/bin/ruby
require_relative 'smallautomata'


$debug = true
$depth = 2

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

def statify(emitee)
  stateA = ['a','@']
  if stateA.include? emitee
    return :a
  else
    return emitee.to_sym
  end
end
def emitify(value)
  emitNull = [:start,:end]
  if emitNull.include? value
    return ''
  else
    return value
  end
end

pa = SmallAutomata.new()
pa.start=:start
total = 0

fd = File.open("abtest.txt","w")
$wd.each do |startState, transition|
  total = transition.inject(0) {|result, (endState, value)| result+value}
  transition.each do |endState, value|
    pa.addEdge(statify(startState),statify(endState),emitify(endState),(1.0*value/total))
	  fd.write "#{startState} to #{endState}:\t#{value}\n"
  end
end
fd.close
puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
puts pa.to_s
puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
