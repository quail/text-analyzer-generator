#include <stdio.h>
#include <math.h>
#include "stirling.h"

double log_factorial_exact(int n)
{
  int k;
  double ans = 0.0;
  for (k=1; k<=n; ++k) {
    ans += log((double)k);
  }

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
