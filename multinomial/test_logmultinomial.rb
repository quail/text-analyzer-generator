require_relative 'logmultinomial'

def log_factorial_exact(n)
  ans = 0.0
  for k in 1..n
    ans += Math.log(k)
  end
  return ans
end

def log_multinomial_exact(x,p)
  n=0
  a=0.0
  x.zip(p).each do |xi,pi|
    n += xi
    a += xi*Math.log(pi) - log_factorial_exact(xi)
  end
  a += log_factorial_exact(n)
  return a
end

def log_multinomial(x,p)
  lm=LogMultinomial.new()
  x.zip(p).each { |xi,pi|  lm.add(xi,pi) }
  return lm.result()
end

def main
  p1 = 0.1
  p2 = 0.2
  p3 = 0.3
  p4 = 0.4

  max_eps = 0.0
  for x1 in 0..2
    for x2 in 0..2
      for x3 in 0..2
        for x4 in 0..2
          p=[p1,p2,p3,p4]
          x=[x1,x2,x3,x4]

          a_exact = log_multinomial_exact(x,p)
          a_approx = log_multinomial(x,p)
          if a_exact != a_approx
            eps = (a_approx - a_exact)/a_exact
          else
            eps = 0.0
          end

          if eps.abs > max_eps
            max_eps = eps.abs
          end
        end
      end
    end
  end
  puts "max eps=#{max_eps}"
end

main
