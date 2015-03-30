#include <stdio.h>
#include <math.h>
#include "log_factorial.h"

double log_factorial_exact(int n)
{
  int k;
  long double ans = 0.0;
  for (k=1; k<=n; ++k) {
    ans += log((double)k);
  }

  return ans;
}

int main()
{
  int i;
  double max_eps = 0.0;
  for (i=0; i<=1000; ++i) {
    double lfe=log_factorial_exact(i);
    double lfa=log_factorial(i);
    double eps=(lfa-lfe)/lfe;
    if (lfa == lfe) {
      eps = 0.0;
    }
    if (fabs(eps) > max_eps) {
      max_eps = fabs(eps);
    }

    printf("i=%d,lfe=%lf, lfa=%lf, eps=%lg\n",i,lfe,lfa, eps);
  }
  printf("max eps=%lg\n",max_eps);
  return 0;
}
