require_relative 'log_factorial'

def log_multinomial(x,p)
  n=0
  a=0.0
  x.zip(p).each do |xi,pi|
    n += xi
    a += xi*Math.log(pi) - log_factorial(xi)
  end
  a += log_factorial(n)
  return a
end
