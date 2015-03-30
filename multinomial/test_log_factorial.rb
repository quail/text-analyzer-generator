require_relative 'log_factorial'

def log_factorial_exact(n)
  ans = 0.0
  for k in 1..n
    ans += Math.log(k)
  end
  return ans
end

def main
  max_eps = 0.0;
  for i in 0..1000
    lfe=log_factorial_exact(i);
    lfa=log_factorial(i);
    eps=(lfa-lfe)/lfe;
    if lfa == lfe
      eps = 0.0;
    end

    if eps.abs > max_eps
      max_eps = eps.abs
    end
  end

  puts "max eps=#{max_eps}"
end

main

