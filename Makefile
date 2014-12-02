COUNT=1000
PMIN=0.0001
REPS=0.0000001

all : words.csv words-1.db words-2.db words-3.db words-4.db words-5.db words-6.db words-1.out words-2.out words-3.out words-4.out words-5.out words-6.out

tests : test1.ok test2.ok
%.csv : split.rb freqcount.rb %.txt
	./split.rb --out $@ $<

words-%.db : tally.rb freqcount.rb words.csv
	./tally.rb --length $* --save $@ --csv words.csv

words-%.out : lorem.rb freqcount.rb  words-%.db
	./lorem.rb --load $< --count $(COUNT) --out $@

test%.out : split.rb tally.rb lorem.rb lorems.rb freqcount.rb test%.txt
	./split.rb --out test$*.csv test$*.txt
	./tally.rb --length 1 --save test$*-1.db --csv test$*.csv
	./tally.rb --length 2 --save test$*-2.db --csv test$*.csv
	./tally.rb --length 3 --save test$*-3.db --csv test$*.csv
	echo "length,word,p,P,b,B" > test$*.out
	./lorems.rb --load test$*-1.db --pmin $(PMIN) | sed 's/^/1,/' >> test$*.out
	./lorems.rb --load test$*-2.db --pmin $(PMIN) | sed 's/^/2,/' >> test$*.out
	./lorems.rb --load test$*-3.db --pmin $(PMIN) | sed 's/^/3,/' >> test$*.out

test%.ok : test%.out test%.vfy
	./csv_cmp.rb -a test$*.out -b test$*.vfy --rel $(REPS) > test$*.ok
