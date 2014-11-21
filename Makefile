COUNT=1000

all : words.csv words-1.db words-2.db words-3.db words-4.db words-5.db words-6.db words-1.out words-2.out words-3.out words-4.out words-5.out words-6.out

words.csv : split.rb words.txt
	./split.rb --out words.csv words.txt

words-%.db : tally.rb words.csv
	./tally.rb --length $* --save $@ --csv words.csv

words-%.out : words-%.db
	./lorem.rb --load $< --count $(COUNT) --out $@
