module systolic_matrix_mul_4x4 (
    input wire clk,                   // Clock signal
    input wire rst,                   // Reset signal
    input wire [31:0] a_0,            // 4x4 input matrix A
    input wire [31:0] a_1,            // 4x4 input matrix A
    input wire [31:0] a_2,            // 4x4 input matrix A
    input wire [31:0] a_3,            // 4x4 input matrix A

    input wire [31:0] b_0,            // 4x4 input matrix B
    input wire [31:0] b_1,            // 4x4 input matrix B
    input wire [31:0] b_2,            // 4x4 input matrix B
    input wire [31:0] b_3, 
    input wire flag,           // 4x4 input matrix B

    // 4x4 output matrix C
    output wire [31:0] c_00,   
    output wire [31:0] c_01,   
    output wire [31:0] c_02,   
    output wire [31:0] c_03,   
    output wire [31:0] c_10,   
    output wire [31:0] c_11,   
    output wire [31:0] c_12,   
    output wire [31:0] c_13,   
    output wire [31:0] c_20,   
    output wire [31:0] c_21,   
    output wire [31:0] c_22,   
    output wire [31:0] c_23,   
    output wire [31:0] c_30,   
    output wire [31:0] c_31,   
    output wire [31:0] c_32,   
    output wire [31:0] c_33    
);

    // Internal connections for the intermediate a, b, and c values
    wire [31:0] a_reg[0:3][0:3];
    wire [31:0] b_reg[0:3][0:3];
    wire [31:0] c_reg[0:3][0:3];

    // Row 0
    systolic_unit pe00 (.a(a_0), .b(b_0), .clk(clk), .rst(rst),.flag(flag), .c_out(c_00), .a_out(a_reg[0][0]), .b_out(b_reg[0][0]));
    systolic_unit pe01 (.a(a_1), .b(b_reg[0][0]), .clk(clk), .rst(rst),.flag(flag), .c_out(c_01), .a_out(a_reg[0][1]), .b_out(b_reg[0][1]));
    systolic_unit pe02 (.a(a_2), .b(b_reg[0][1]), .clk(clk), .rst(rst),.flag(flag), .c_out(c_02), .a_out(a_reg[0][2]), .b_out(b_reg[0][2]));
    systolic_unit pe03 (.a(a_3), .b(b_reg[0][2]), .clk(clk), .rst(rst),.flag(flag), .c_out(c_03), .a_out(a_reg[0][3]), .b_out(b_reg[0][3]));

    // Row 1
    systolic_unit pe10 (.a(a_reg[0][0]), .b(b_1), .clk(clk), .rst(rst),.flag(flag), .c_out(c_10), .a_out(a_reg[1][0]), .b_out(b_reg[1][0]));
    systolic_unit pe11 (.a(a_reg[0][1]), .b(b_reg[1][0]), .clk(clk), .rst(rst),.flag(flag), .c_out(c_11), .a_out(a_reg[1][1]), .b_out(b_reg[1][1]));
    systolic_unit pe12 (.a(a_reg[0][2]), .b(b_reg[1][1]), .clk(clk), .rst(rst),.flag(flag), .c_out(c_12), .a_out(a_reg[1][2]), .b_out(b_reg[1][2]));
    systolic_unit pe13 (.a(a_reg[0][3]), .b(b_reg[1][2]), .clk(clk), .rst(rst),.flag(flag), .c_out(c_13), .a_out(a_reg[1][3]), .b_out(b_reg[1][3]));

    // Row 2
    systolic_unit pe20 (.a(a_reg[1][0]), .b(b_2), .clk(clk), .rst(rst),.flag(flag), .c_out(c_20), .a_out(a_reg[2][0]), .b_out(b_reg[2][0]));
    systolic_unit pe21 (.a(a_reg[1][1]), .b(b_reg[2][0]), .clk(clk), .rst(rst),.flag(flag), .c_out(c_21), .a_out(a_reg[2][1]), .b_out(b_reg[2][1]));
    systolic_unit pe22 (.a(a_reg[1][2]), .b(b_reg[2][1]), .clk(clk), .rst(rst),.flag(flag), .c_out(c_22), .a_out(a_reg[2][2]), .b_out(b_reg[2][2]));
    systolic_unit pe23 (.a(a_reg[1][3]), .b(b_reg[2][2]), .clk(clk), .rst(rst),.flag(flag), .c_out(c_23), .a_out(a_reg[2][3]), .b_out(b_reg[2][3]));

    // Row 3
    systolic_unit pe30 (.a(a_reg[2][0]), .b(b_3), .clk(clk), .rst(rst),.flag(flag), .c_out(c_30), .a_out(a_reg[3][0]), .b_out(b_reg[3][0]));
    systolic_unit pe31 (.a(a_reg[2][1]), .b(b_reg[3][0]), .clk(clk),.flag(flag), .rst(rst), .c_out(c_31), .a_out(a_reg[3][1]), .b_out(b_reg[3][1]));
    systolic_unit pe32 (.a(a_reg[2][2]), .b(b_reg[3][1]), .clk(clk),.flag(flag), .rst(rst), .c_out(c_32), .a_out(a_reg[3][2]), .b_out(b_reg[3][2]));
    systolic_unit pe33 (.a(a_reg[2][3]), .b(b_reg[3][2]), .clk(clk),.flag(flag), .rst(rst), .c_out(c_33), .a_out(a_reg[3][3]), .b_out(b_reg[3][3]));

endmodule
