module systolic_matrix_mul_2x2(
    input wire clk,              // Clock signal
    input wire rst,              // Reset signal
    input wire [31:0] a00,
    input wire [31:0] a01,      // Input matrix A (0,0)
    input wire [31:0] b00,
    input wire [31:0] b01,        // Input matrix B (0,0)
    output wire [31:0] c00,      // Output matrix C (0,0)
    output wire [31:0] c01,      // Output matrix C (0,1)
    output wire [31:0] c10,      // Output matrix C (1,0)
    output wire [31:0] c11       // Output matrix C (1,1)
);

// Internal registers to store intermediate values
wire [31:0] a_reg00, a_reg01, a_reg10, a_reg11;
wire [31:0] b_reg00, b_reg01, b_reg10, b_reg11;
wire [31:0] c_reg00, c_reg01, c_reg10, c_reg11;

// Instantiate the first PE for C(0,0)
systolic_unit pe00(
    .a(a00),
    .b(b00),
    .c(c_reg00),
    .clk(clk),
    .rst(rst),
    .a_out(a_reg00),
    .b_out(b_reg00),
    .c_out(c00)
);

// Instantiate the second PE for C(0,1)
systolic_unit pe01(
    .a(a_reg00),
    .b(b01),  // Systolic pattern: pass value from below
    .c(c_reg01),
    .clk(clk),
    .rst(rst),
    .a_out(a_reg01),
    .b_out(b_reg01),
    .c_out(c01)
);

// Instantiate the third PE for C(1,0)
systolic_unit pe10(
    .a(a01),
    .b(b_reg00),    // Systolic pattern: pass value from the right
    .c(c_reg10),
    .clk(clk),
    .rst(rst),
    .a_out(a_reg10),
    .b_out(b_reg10),
    .c_out(c10)
);

// Instantiate the fourth PE for C(1,1)
systolic_unit pe11(
    .a(a_reg10),
    .b(b_reg01),  
    .c(c_reg11),
    .clk(clk),
    .rst(rst),
    .a_out(a_reg11),
    .b_out(b_reg11),
    .c_out(c11)
);

endmodule
