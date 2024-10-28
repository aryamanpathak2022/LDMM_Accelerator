#ifndef KARATSUBA_H
#define KARATSUBA_H

#include <stdio.h>
#include <math.h>
#define MATRIX_DIM 4  // Define the matrix size

// Function to calculate the number of digits in a number
long long multiply(long long a, long long b);

// Recursive Karatsuba function to multiply two large numbers
long long karatsuba(long long x, long long y);

#endif // KARATSUBA_H
