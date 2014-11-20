#!/usr/bin/ruby

class FreqCount
  def initialize(length)
    @length=length
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
  end

  def save(file)
    fd = File.open(file,"wb")
    Marshal.dump(@length,fd)
    Marshal.dump(@weights,fd)
    fd.close()
  end

  def load(file)
    fd = File.open(file,"rb")
    @length=Marshal.load(fd)
    @weights=Marshal.load(fd)
    fd.close()
  end

  def _lorems(pmin,pmax,p,at,word,&block)
    tmp=@weights
    at.each do |sk|
      tmp=tmp[sk]
    end
    total = 0
    tmp.each { |char,weight| total = total + weight }
    total = total.to_f

    tmp.each do |char,weight|
      p1 = p*weight/total
      if char == :end then
        if pmin <= p1 and p1 < pmax then
          yield word,p1
        end
      elsif (p1 >= pmin) then
        word1 = word.dup
        word1 << char
        at1 = at.dup
        at1.shift
        at1 << char
        _lorems(pmin,pmax,p1,at1,word1,&block)
      end
    end
  end

  def lorems(pmin,pmax,&block)
    p=1.0
    at=Array.new(@length-1,:start)
    word=""
    _lorems(pmin,pmax,p,at,word,&block)
  end
  
  def lorem
    word=""
    prob=1
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
          prob = prob * (weight/total)
          if char != :end then
            word << char
          end
          break
        else
          p = p - weight
        end
      end
    end
    return [word,prob]
  end
  def to_s
    "[length=#{@length}, total=#{@total}]: #{@weights}"
  end
end
