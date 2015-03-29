#/usr/bin/ruby
require_relative 'smallautomata'


$debug = false
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
def text2PA
  pa = SmallAutomata.new()
  pa.start=:start
  total = 0

  fd = File.open("abtest.txt","w")
  $wd.each do |startState, transition|
    total = transition.inject(0) {|result, (endState, value)| result+value}
    transition.each do |endState, value|
      pa.addEdge(statify(startState),statify(endState),emitify(endState),(value.to_f/total))
	    fd.write "#{startState} to #{endState}:\t#{value}\n"
    end
  end
  fd.close
  return pa
end
def words(pa,count)
  words = Hash.new()
  count.times do
    word = ""
    pa.run { |ek,pk| word << ek }
    words[word] = (words[word]||0)+1
  end

  return words
end

def stats(pa,n,m)
  all_words = Hash.new()
  m.times do
    words(pa,n).each do |word,count|
      if not all_words.has_key?(word) then
        emits = []
        word.each_char { |char| emits << char }
        emits << ""
        prob1 = pa.likelyhood(emits)
        prob2 = count.to_f/n
        sigma = Math.sqrt(prob1*(1-prob1)/n.to_f)
        z = (prob2-prob1)/sigma
        all_words[word]=[prob1,sigma,z]
      else
        stats = all_words[word]
        prob1 = stats[0]
        sigma = stats[1]
        prob2 = count.to_f/n
        z = (prob2-prob1)/sigma
        all_words[word] << z
      end
    end
  end

  return all_words
end

n = 1000000
m = 100
eps = 0.1

pa = text2PA()

words = stats(pa,n,m)
fd = File.open("abStatistics.txt","w")
fd.write "Word, probability, standard deviation,Average z-score, z-score std deviation\n"
words.each do |word,stats|
  prob = stats[0]
  sigma = stats[1]
  sum0 = 0
  sum1 = 0
  sum2 = 0
  stats[2..-1].each do |z|
    sum0 += 1
    sum1 += z
    sum2 += z*z
  end
  zbar = sum1/sum0
  zsigma = Math.sqrt((1.0/(sum0-1))*sum2)
  if sigma < eps*prob then
    fd.write "#{word},#{prob},#{sigma},#{sum0},#{zbar},#{zsigma}\n"
  end
end
fd.close