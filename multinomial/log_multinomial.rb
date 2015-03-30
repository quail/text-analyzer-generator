# require_relative 'log_factorial'

def log_multinomial(x,p)
  n=0
  a=0.0
  x.zip(p).each do |xi,pi|
    n += xi
    a += xi*Math.log(pi) - Math.lgamma(xi+1)[0]
  end
  a += Math.lgamma(n+1)[0]
  return a
end
