#/usr/bin/ruby
require_relative 'smallautomata'


$debug = false
$depth = 2

$filename = "ab.txt"
$nameWithoutExtension = File.basename($filename,".*")

$alpha = 0.01
$beta  = 0.005

def countChars
  fc = Hash.new()

  count=0
  File.open($filename).each do |line|
    line.gsub!(' ','')
    line.strip.each_char { |c| fc[c] = (fc[c]||0) + 1 }
    count=count+1
  end

  if count > 0 then
    fc[:start]=count
    fc[:end]=count
  end
  fc[:count]=count
  return fc
end

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

File.open($filename).each do |line|
  $at = Array.new($depth,:start)
  line.gsub!(' ','')
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
def text2PA
  pa = SmallAutomata.new()
  pa.start=:start
  total = 0
  probCounter = 0
  fc = countChars()
  fd = File.open("#{$nameWithoutExtension}test.txt","w")
  $wd.each do |startState, transition|
    total = transition.inject(0) {|result, (endState, value)| result+value}
    transition.each do |endState, value|
      pa.addEdge(statify(startState),statify(endState),emitify(endState),(1.0-$beta)*(value.to_f/total))
      #puts "@=#{fc['@']}"
      pa.addEdge(statify(startState),statify(startState),'a',($beta)*((fc['a']+fc['@'])/fc[:count]))
      pa.addEdge(statify(startState),statify(startState),'b',($beta)*(fc['b']/fc[:count]))
      totalProb = $beta*(fc['a']+fc['@'])/fc[:count]+($beta)*(fc['b']/fc[:count])+(1.0-$beta)*(value.to_f/total)
      #puts "Total prob: #{totalProb}"
      probCounter+=totalProb
	    fd.write "#{startState} to #{endState}: #{value}\n"
    end
  end
  fd.close
  puts "Probcounter: #{probCounter}"
  return pa
end

pa=text2PA()

#puts pa.to_s