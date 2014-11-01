require 'csv'

class String
  def generateNgrams(n, sepChar)
    self.split(sepChar).each_cons(n).to_a
  end
end
class Time
  def to_ms
      (self.to_f * 1000.0)#adding this method to class Time for precision's sake
  end
end

def weightedWord(someHash,sepChar)
  randomNum = rand()
  someHash.each do |word, probability|
    return word.join(sepChar) if randomNum <= probability
    randomNum -= probability
  end
end

def generateMarkovText(length, wordHash, n=1, sepChar) #length: how many words (ngrams) to generate, wordHash: hash containing the probabilities of every word, n: n-gram
  keys = wordHash.keys
  word = keys[rand(keys.size)].join(sepChar)
  output = word
  iterations = length/n
  iterations.times do 
    newWord = weightedWord(wordHash,sepChar)
    if (newWord)
      word = newWord
      output += sepChar + word
    else
      word = keys[rand(keys.size)].join(sepChar)
    end
  end
  outputFile = "generatedText.txt"
  File.open(outputFile, 'w') {|f| f.write(output)}
  return output
end


N = 4 #n in n-grams
separator = ' '# " " for words, "" for characters
t1 = Time.now.to_ms
file = 'aliceinwonderland.txt' #training text
ngrams = []
File.open(file).each_line do |line| 
      ngrams << line.generateNgrams(N, separator)
end
ngrams.flatten!(1) #splits training text into ngrams

tally = Hash.new(0)
ngrams.each do |ngram| #computes frequencies of each ngram
  tally[ngram] += 1
end
total = tally.values.inject { |sum,count| sum + count } #computes total number of ngrams


probabilities = Hash.new(0)
tally.each do |key, value|
  probabilities[key]=value.to_f/total #makes probability table
end

textLength= 10000 #how much text to generate
generateMarkovText(textLength, probabilities, N, separator)
t2 = Time.now.to_ms

puts "Time to complete #{t2-t1} ms"

CSV.open("frequency.csv", "wb") do |csv| #write frequency table to CSV for further consultation
  csv << ["Word", "Frequency"]
  tally.each do |key, value|
    csv << [key.join(separator), value]
  end
end
###TO DO###########################################
#use letters, strip punctuation, go to lower case.
#Conditional probabilities with :start and :end symbols
###################################################