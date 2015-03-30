#include "logmultinomial.h"

LogMultinomial::LogBinomail() : a(0.0), N(0.0) {}
void LogMultinomial::reset() { a=0; N=0; }
void LogMultinomial::add(int x, double p) {
  N += x;
  a += x*log(p)-log_factorial(x);
}

double LogMultinomial::result() const {
  if (N > 0) {
    a += log_factorial(N);
    N = 0;
  }
  return a;
}
