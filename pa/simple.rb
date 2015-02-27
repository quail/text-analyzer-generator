require 'csv'
require_relative 'smallautomota'
require_relative 'simplepa'

pa = SimplePA()

1000000.times do
  word = ""
  pa.run { |ek,pk| word << ek }
  puts word
end

