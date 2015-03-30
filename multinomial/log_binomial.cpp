#include "log_binomial.h"

LogBinomial::LogBinomail() : a(0.0), N(0.0) {}
void LogBinomial::reset() { a=0; N=0; }
void LogBinomial::add(int x, double p) {
  N += x;
  a += x*log(p)-log_factorial(x);
}

double LogBinomial::result() {
  if (N > 0) {
    a += log_factorial(N);
    N = 0;
  }
  return a;
}
