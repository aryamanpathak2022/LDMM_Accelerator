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
reg [63:0] c_reg;
wire [63:0] karatsuba_result;

// Instantiate the Karatsuba MAC unit
karatsuba_mac karatsuba_inst (
    .A(a),
    .B(b),
    .result(karatsuba_result)
);

initial begin
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
        // Use Karatsuba multiplication result for updating 'c'
        c_reg = c_reg + karatsuba_result;
        a_out <= a;
        b_out <= b;
        c_out = c_reg[31:0]; // Only take the lower 32 bits for c_out

        // Debugging print statements
        $display("systolic_unit:");
        $display("a = %d, b = %d, c_out = %d c_reg=%d", a, b, c_out, c_reg);
    end
end

endmodule
