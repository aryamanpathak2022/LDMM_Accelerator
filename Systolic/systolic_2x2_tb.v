module systolic_unit(
    input wire [31:0] a,       // 32-bit input 'a'
    input wire [31:0] b,       // 32-bit input 'b'     
    input wire clk,            // Clock signal
    input wire rst,            // Reset signal
    output reg [31:0] a_out,   // 32-bit output 'a'
    output reg [31:0] b_out,   // 32-bit output 'b'
    output reg [31:0] c_out    // 32-bit output 'c'
);

// Internal register to store the updated 'c'
reg [31:0] c_reg;
initial
begin
    c_reg = 0;
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        // Reset the values to 0 on reset
        a_out <= 0;
        b_out <= 0;
        c_out <= 0;
        c_reg <= 0;
    end else begin
        // Update 'c' and output the values
        c_reg = c_reg + a * b;
        a_out <= a;
        b_out <= b;
        c_out = c_reg ; // Use the immediate result of the calculation
        
        // Debugging print statements
        $display("systolic_unit:");
        $display("a = %d, b = %d, c_out = %d c_reg=%d", a, b, c_out,c_reg);
    end
end

endmodule


module systolic_matrix_mul_2x2(
    input wire clk,              // Clock signal
    input wire rst,              // Reset signal
    input wire [31:0] a00,
    input wire [31:0] a01,       // Input matrix A (0,0)
    input wire [31:0] b00,
    input wire [31:0] b01,       // Input matrix B (0,0)
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
    .clk(clk),
    .rst(rst),
    .a_out(a_reg00),
    .b_out(b_reg00),
    .c_out(c00)
);

// Debugging print for PE00 output
always @(posedge clk) begin
    $display("PE00 - a_out: %d, b_out: %d, c00: %d", a_reg00, b_reg00, c00);
     $display("PE00 - a00: %d, b00: %d, c00: %d", a00, b00, c00);
    
end

// Instantiate the second PE for C(0,1)
systolic_unit pe01(
    .a(a_reg00),
    .b(b01),  // Systolic pattern: pass value from below
    .clk(clk),
    .rst(rst),
    .a_out(a_reg01),
    .b_out(b_reg01),
    .c_out(c01)
);

// Debugging print for PE01 output
always @(posedge clk) begin
    $display("PE01 - a_out: %d, b_out: %d, c01: %d", a_reg01, b_reg01, c01);
end

// Instantiate the third PE for C(1,0)
systolic_unit pe10(
    .a(a01),
    .b(b_reg00),    // Systolic pattern: pass value from the right
    .clk(clk),
    .rst(rst),
    .a_out(a_reg10),
    .b_out(b_reg10),
    .c_out(c10)
);

// Debugging print for PE10 output
always @(posedge clk) begin
    $display("PE10 - a_out: %d, b_out: %d, c10: %d", a_reg10, b_reg10, c10);
end

// Instantiate the fourth PE for C(1,1)
systolic_unit pe11(
    .a(a_reg10),
    .b(b_reg01),  
    .clk(clk),
    .rst(rst),
    .a_out(a_reg11),
    .b_out(b_reg11),
    .c_out(c11)
);

// Debugging print for PE11 output
always @(posedge clk) begin
    $display("PE11 - a_out: %d, b_out: %d, c11: %d", a_reg11, b_reg11, c11);
end

endmodule


module test_systolic_matrix_mul_2x2();
  // Inputs
  reg clk;
  reg rst;
  reg [31:0] a00, a01;
  reg [31:0] b00, b01;

  // Outputs
  wire [31:0] c00, c01, c10, c11;

  // Instantiate the systolic matrix multiplication module
  systolic_matrix_mul_2x2 uut (
    .clk(clk),
    .rst(rst),
    .a00(a00),
    .a01(a01),
    .b00(b00),
    .b01(b01),
    .c00(c00),
    .c01(c01),
    .c10(c10),
    .c11(c11)
  );

  // Clock generation
  always #5 clk = ~clk;  // Clock with 10-time unit period

  // Test stimulus
  initial begin
    // Initialize the inputs
    clk = 0;
    rst = 1;

    // Hold reset for a few cycles
    #10;
    rst = 0;

    // Test Case 1
    a00 = 32'd1;  a01 = 32'd0;
    b00 = 32'd1;  b01 = 32'd0;

    #10
    // Test Case 2
    a00 = 32'd1;  a01 = 32'd1;
    b00 = 32'd1;  b01 = 32'd1;

    #10
    // Test Case 3
    a00 = 32'd0;  a01 = 32'd1;
    b00 = 32'd0;  b01 = 32'd1;
    #10
     a00 = 32'd0;  a01 = 32'd0;
    b00 = 32'd0;  b01 = 32'd0;
    

    // Wait and display final results
    #50;
    $display("Final Results:");
    $display("C(0,0) = %d", c00);
    $display("C(0,1) = %d", c01);
    $display("C(1,0) = %d", c10);
    $display("C(1,1) = %d", c11);

    // End the simulation
    $stop;
  end

endmodule