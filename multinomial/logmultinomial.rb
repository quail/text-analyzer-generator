require_relative 'log_factorial'

class LogMultinomial
  def initialize
    reset()
  end

  def reset
    @n=0
    @a=0
  end

  def add(x,p)
    @n += x
    @a += x*Math.log(p)-log_factorial(x)
  end

  def result
    if @n > 0
      @a += log_factorial(@n)
      @n = 0
    end
    return @a
  end
end
