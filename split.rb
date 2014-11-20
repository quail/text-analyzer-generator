#!/usr/bin/ruby

require 'csv'

words = Hash.new()
output = STDOUT
state = :initial
weight = 1

ARGV.each do |file|
  case state
  when :initial
    if file == '-h' or file == '--help' then
      print "Usage: split [-h|-help] [-w|--weight 1] [-o|--out] OUTPUT inputs...\n";
      print "  weight: use this per-word weight (default 1)\n"
      print "  out: send output here (/dev/stdout for console)\n"
    elsif file == '-o' or file == '--out' then
      state = :arg_out
    elsif file == '-w' or file == '--weight' then
      state = :arg_weight
    else
      if file != "/dev/stdin" then
        fd = File.open(file)
      else
        fd = STDIN
      end
      fd.each_line do |line|
        line.downcase.scan(/([a-z]+)('[a-z]{1,2})?/) do |word,apos|
          if not apos.nil? then
            word << apos[1..-1]
          end
          words[word]=(words[word]||0)+weight
        end
      end
    end
  when :arg_out
    if file != "/dev/stdout" then
      output=File.open(file,"w")
    else
      output=STDOUT
    end
    state = :initial
  when :arg_weight
    weight=file.to_f
    state = :initial
  end
end

csv = CSV.new(output)
words.map.sort { |a,b| b[1] <=> a[1] }.each { |row| csv<<row }
csv.close
