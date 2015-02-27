require_relative 'smallautomota'

n = 10000000

# create an automota with duplicated emits (b->a and b->b both emit 'x')
pa = SmallAutomota.new()
pa.start=:start
pa.addEdge(:start,:a,'a',(1.0/3.0))
pa.addEdge(:start,:b,'b',(2.0/3.0))
pa.addEdge(:a,:a,'a',0.5*(1.0/3.0))
pa.addEdge(:a,:b,'b',0.5*(2.0/3.0))
pa.addEdge(:a,:end,'',0.5)
pa.addEdge(:b,:a,'x',0.5*(1.0/3.0))
pa.addEdge(:b,:b,'x',0.5*(2.0/3.0))
pa.addEdge(:b,:end,'',0.5)

words = Hash.new()

# generate n words using the PA
n.times do
  word = ""
  pa.run { |ek,pk| word << ek }
  words[word] = (words[word]||0)+1
end

# go through the more frequent words
# and check that the theory matches
# the sample
#
limit = Math.sqrt(n)
words.each do |word,count|
  if count >= limit then
    emits = []
    word.each_char { |char| emits << char }
    emits << ""
    prob1 = count.to_f/n.to_f
    prob2 = pa.likelyhood(emits)
    delta = prob2-prob1
    print "#{word},#{prob1},#{prob2},#{delta}\n"
  end
end
