#include <math.h>
#include "stirling.h"

static const double log_factorial_cache[] = {
  0.0,
  0.0,
  0.69314718055994530941723212145817656807550013436025525412068,
  1.79175946922805500081247735838070227272299069218300470585537,
  3.17805383034794561964694160129705540887399096090351521409674,
  4.78749174278204599424770093452324304839959231517203293600938,
  6.57925121201010099506017829290394532112258300735503764186476,
  8.52516136106541430016553103634712505075966773693689883032415,
  10.6046029027452502284172274007216547549861681400176645926862,
  12.8018274800814696112077178745667061642811492556631634961556
};

double log_factorial(int n)
{
  if (n < 10) {
    return log_factorial_cache[n];
  }
  
  double h1=1.0/n;
  double h2=h1*h1;
  double ans = 0.0;

  /* O((1/n)^19) error */
  /* http://en.wikipedia.org/wiki/Stirling%27s_approximation */

  ans = 43867.0/(3*3*7*17*19);
  ans = ans*h2-3617.0/(2*2*2*3*5*5*17);
  ans = ans*h2+1.0/(2*2*3*13);
  ans = ans*h2-691.0/(2*2*2*3*3*5*7*11*13);
  ans = ans*h2+1.0/(2*2*3*3*3*11);
  ans = ans*h2-1.0/(2*2*2*2*3*5*7);
  ans = ans*h2+1.0/(2*2*3*3*5*7);
  ans = ans*h2-1.0/(2*2*2*3*3*5);
  ans = ans*h2+1.0/(2*2*3);
  ans = h1*ans+0.5*log(2*M_PI*n)-n+n*log(n);

  return ans;
}

int main()
{
  int i;
  for (i=0; i<100; ++i) {
    double lfe=log_factorial_exact(i);
    double lfa=log_factorial(i);
    double eps=(lfa-lfe)/lfe;
    if (lfa == lfe) {
      eps = 0.0;
    }

    printf("i=%d,lfe=%lf, lfa=%lf, eps=%lg\n",i,lfe,lfa, eps);
  }
  return 0;
}
