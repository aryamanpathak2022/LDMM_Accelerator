#include <stdio.h>
#include <math.h>
#include "karatsuba.h"




// Systolic array implementation
void systolic_array(long long A[MATRIX_DIM][MATRIX_DIM], long long B[MATRIX_DIM][MATRIX_DIM], long long C[MATRIX_DIM][MATRIX_DIM]) {
    for (int i = 0; i < MATRIX_DIM; i++) {
        for (int j = 0; j < MATRIX_DIM; j++) {
            long long sum = 0;
            for (int k = 0; k < MATRIX_DIM; k++) {
                sum += karatsuba(A[i][k] , B[k][j]);
            }
            C[i][j] = sum;
        }
    }
}
