require_relative 'simplepa'

#
# create m sets of n words using the simple probablistic automota.
# compute the theoreticial likelyhood of each generated word, which
# in a random sampling, should appear as a binomial distribution.
# Compare the results of the m sets according to that distribution,
# for each word with enough samples (n) so that the deviation in the
# expected number of appearences is small (eps)
#
#    expected-value/standard-deviation  < eps
#
# if p is the likelyhood of a word, then the s.d. is sqrt(p*(1-p)/n)
# of the sampling.  The z-score of the sample likelyhood using the above
# likelyhood and and s.d. is used to check the theoretical results.  The
# output is a csv list of the form:
#
#   word,p,sigma,count,zbar,zsigma
#
# word - the generated word (generated at least once in the m*n trials)
# p - the theoretical likelyhood that word was generated
# sigma - sqrt(p*(p-1)/n) the expected deviation in p when sampling the
#         p.a. n times
# count - number of times the word appeared at least once in the m trials.
# zbar - the average z-score z=(p_sample-p)/sigma for the m trials
# zsigma - the sample standard deviation of the z-scores.
#
# These numbers are only reported for words which are well sampled, that
# is,  p/sigma < eps
#
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

pa = SimplePA()

words = stats(pa,n,m)

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
    print "#{word},#{prob},#{sigma},#{sum0},#{zbar},#{zsigma}\n"
  end
end
