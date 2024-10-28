#include "E:/LDMMA/partb/karatsuba.h"
#include <stdio.h>

#define MATRIX_DIM 4

// Function to perform regular matrix multiplication
void normal_matrix_multiply(long long A[MATRIX_DIM][MATRIX_DIM], long long B[MATRIX_DIM][MATRIX_DIM], long long C[MATRIX_DIM][MATRIX_DIM]) {
    for (int i = 0; i < MATRIX_DIM; i++) {
        for (int j = 0; j < MATRIX_DIM; j++) {
            C[i][j] = 0;
            for (int k = 0; k < MATRIX_DIM; k++) {
                C[i][j] += A[i][k] * B[k][j];
            }
        }
    }
}

// Main function
int main() {
    long long A[MATRIX_DIM][MATRIX_DIM] = {{1, 2, 3, 4}, {5, 6, 7, 8}, {9, 10, 11, 12}, {13, 14, 15, 16}};
    long long B[MATRIX_DIM][MATRIX_DIM] = {{16, 15, 14, 13}, {12, 11, 10, 9}, {8, 7, 6, 5}, {4, 3, 2, 1}};
    long long  C_systolic[MATRIX_DIM][MATRIX_DIM];  // Result using systolic array
    long long C_normal[MATRIX_DIM][MATRIX_DIM];    // Result using normal multiplication

    // Perform multiplication using systolic array (Karatsuba-based)
    systolic_array(A, B, C_systolic);

    // Perform multiplication using normal method
    normal_matrix_multiply(A, B, C_normal);

    // Print the result matrix from systolic array
    printf("Result matrix from systolic array:\n");
    for (int i1 = 0; i1 < MATRIX_DIM; i1++) {
        for (int j1 = 0; j1 < MATRIX_DIM; j1++) {
            printf("%lld ", C_systolic[i1][j1]);
        }
        printf("\n");
    }

    // Print the result matrix from normal multiplication
    printf("\nResult matrix from normal multiplication:\n");
    for (int i2 = 0; i2 < MATRIX_DIM; i2++) {
        for (int j2 = 0; j2 < MATRIX_DIM; j2++) {
            printf("%lld ", C_normal[i2][j2]);
        }
        printf("\n");
    }

    // Compare the two results to check for correctness
    int correct = 1;
    for (int i3 = 0; i3 < MATRIX_DIM; i3++) {
        for (int j3 = 0; j3 < MATRIX_DIM; j3++) {
            if (C_systolic[i3][j3] != C_normal[i3][j3]) {
                correct = 0;
                break;
            }
        }
    }

    if (correct) {
        printf("\nThe systolic array multiplication is correct!\n");
    } else {
        printf("\nThere is a mismatch in the multiplication results.\n");
    }

    return 0;
}
