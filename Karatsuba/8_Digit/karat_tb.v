// Testbench for verifying the Karatsuba MAC multiplier
module test_karatsuba_mac();
    reg [31:0] A, B;
    wire [63:0] result;

    // Instantiate the Karatsuba MAC multiplier module
    karatsuba_mac uut (
        .A(A),
        .B(B),
        .result(result)
    );

    initial begin
        // Apply test cases
        A = 32'd12345678;  // Example input 1
        B = 32'd87654321;  // Example input 2

        #10;
        $display("A = %d, B = %d, Result = %d", A, B, result);

        // Test with another case
        A = 32'd11111111;
        B = 32'd22222222;

        #10;
        $display("A = %d, B = %d, Result = %d", A, B, result);

        // End the simulation
        #10;
        $finish;
    end
endmodule