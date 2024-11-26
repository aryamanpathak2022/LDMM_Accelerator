# Large Dimension Matrix Multiplier Accelerator

This repository implements a high-performance matrix multiplier accelerator using a **systolic array architecture** to handle large-dimension matrices. The design replaces the traditional MAC (Multiply-Accumulate) units within the systolic array with **Karatsuba multipliers** to enhance the efficiency and speed of matrix multiplications.

## Table of Contents
- [Overview](#overview)
- [Features](#features)
- [Folder Structure](#folder-structure)
- [Implementation Details](#implementation-details)

## Overview
Matrix multiplication is a critical operation in many fields, including scientific computing, machine learning, and computer graphics. Traditional MAC-based multipliers are efficient but can become computationally expensive for large matrices. This project accelerates the multiplication by:
1. Using a **systolic array** to perform the operations in parallel.
2. Replacing the MAC units with **Karatsuba multipliers**, which are known for their efficiency in large integer multiplication.

### Supported Matrix Dimensions
- 4x4
- 8x8  
Other dimensions can be added with minimal modification to the systolic array configuration.

## Features
- **Systolic Array Design:** Enables parallel processing of matrix multiplications for increased throughput.
- **Karatsuba Multiplier Integration:** Replaces the conventional MAC operation for optimized multiplication, especially beneficial for large-dimension matrices.
- **Verilog and C++ Codebase:** Provides both hardware and simulation models to verify the design functionality.
  
## Folder Structure
```plaintext
├── Systolic/        # Systolic array implementations
├── Karatsuba/       # karatsuba implementation and combination with systolic removing mac
├── README.md        # Project overview and documentation
          
```


## Implementation Details
### Systolic Array
A systolic array is a hardware architecture designed for efficient parallel data processing. In this design:
- Each processing element (PE) performs partial multiplications and additions.
- The array flows data in a pipelined manner, enabling high throughput.

### Karatsuba Multiplier
The Karatsuba algorithm is a divide-and-conquer method that reduces the complexity of large integer multiplication. In this design:
- Each MAC unit in the systolic array is replaced by a Karatsuba multiplier to improve speed for large integer multiplications.
- This substitution is particularly beneficial for high-dimensional matrix multiplication where each element's multiplication cost is high.
