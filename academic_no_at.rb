#!/usr/bin/ruby
# usage: academic_no_at.rb inputs... > output
# removes everything but newlines, a, b and spaces
(ARGV||['/dev/stdin']).each do |file|
  File.open(file).each do |line|
    line = line.downcase
    line.gsub!(/[^ab ]/,'')
    print line
  end
end
