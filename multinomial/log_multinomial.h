#pragma once
#include <vector>

class LogMultinomial
{
 private: double a;
 private: int N;
 public: LogBinomial();
 public: void reset();
 public: void add(int xi, double pi);
 public: double result() const;
};
