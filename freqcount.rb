#!/usr/bin/ruby

class FreqCount
  def initialize(length)
    @length=length
    @total=0
    @random = Random.new()
    @weights = Hash.new()
    @at = Array.new(@length,:start)
  end

  def _process(char,weight)
    tmp=@weights
    @at.shift
    @at.each do |sk|
      if tmp[sk].nil? then
        tmp[sk]=Hash.new()
      end
      tmp=tmp[sk]
    end
    tmp[char]=(tmp[char]||0)+weight
    @at << char
  end

  def add_word(word,weight=1.0)
    @at = Array.new(@length,:start)
    word.each_char { |char| _process(char,weight) }
    _process(:end,weight)
    @total = @total + (weight*(word.length+1))
  end

  def save(file)
    fd = File.open(file,"wb")
    Marshal.dump(@length,fd)
    Marshal.dump(@total,fd)
    Marshal.dump(@weights,fd)
    fd.close()
  end

  def load(file)
    fd = File.open(file,"rb")
    @length=Marshal.load(fd)
    @total=Marshal.load(fd)
    @weights=Marshal.load(fd)
    fd.close()
  end

  def lorem
    ans=""
    @at = Array.new(@length,:start)
    while @at.last != :end do
      @at.shift
      tmp=@weights
      @at.each do |sk|
        tmp=tmp[sk]
      end
      total = 0
      tmp.each { |char,weight| total = total + weight }
      p = total*@random.rand
      tmp.each do |char,weight|
        if p < weight then
          @at << char
          if char != :end then
            ans << char
          end
          break
        else
          p = p - weight
        end
      end
    end
    return ans
  end
  def to_s
    "[length=#{@length}, total=#{@total}]: #{@weights}"
  end
end
