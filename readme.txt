#
# asana - project managment (password)
# sharelatex - what it sounds like (passwordProject)
# drive.google.com (passwordProject)
# github.com (text-analyzer-generator)
#

# Warren MacEvoy -- script tools
#
# Use --help on scripts to get more options
#

split.rb
  splits text into words, counts up by frequency, and creates a csv output

    echo '"Hee hee!" said she."' > hee.txt
    ./split.rb -o hee.csv hee.txt

tally.rb
  adds words in csv file and computes conditional frequencies

    ./tally.rb --length 2 --csv hee.csv --save hee.db

lorem.rb
  creates words using computed frequency data
  
    ./lorem.rb --load hee.db --count 10
  
lorems.rb
   generates words in rough order of probabilty (depth-first traversal)
   for given probability table.


freqcount.rb
   general class the above scripts use.
