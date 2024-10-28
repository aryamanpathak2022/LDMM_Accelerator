#include <stdio.h>
#include <math.h>
#include "karatsuba.h"

// Function to calculate the number of digits in a number
int numDigits(long long num) {
    return num == 0 ? 1 : (int)log10(num) + 1;
}

// Recursive Karatsuba function
long long karatsuba(long long x, long long y) {
    // Base case: if x or y is less than 10, return their product
    if (x < 10 || y < 10) {
        return x * y;
    }

    // Get the number of digits in the larger of x or y
    int n = fmax(numDigits(x), numDigits(y));
    int half = n / 2;

    // Split the numbers into two halves
    long long a = x / (long long)pow(10, half);
    long long b = x % (long long)pow(10, half);
    long long c = y / (long long)pow(10, half);
    long long d = y % (long long)pow(10, half);

    // Recursively calculate products of the parts
    long long ac = karatsuba(a, c);
    long long bd = karatsuba(b, d);
    long long ad_plus_bc = karatsuba(a + b, c + d) - ac - bd;

    // Combine the results
    return ac * (long long)pow(10, 2 * half) + ad_plus_bc * (long long)pow(10, half) + bd;
}

int main() {
    long long x = 123456789;
    long long y = 987654321;

    long long result = karatsuba(x, y);

    printf("Karatsuba multiplication of %lld and %lld is: %lld\n", x, y, result);

    return 0;
}
