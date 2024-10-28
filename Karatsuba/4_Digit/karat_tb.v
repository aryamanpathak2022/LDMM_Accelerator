// Testbench for verifying the Karatsuba MAC multiplier (4-digit version)
module test_karatsuba_mac_4digit();
    reg [15:0] A, B;
    wire [31:0] result;

    // Instantiate the Karatsuba MAC multiplier module (4-digit)
    karatsuba_mac_4digit uut (
        .A(A),
        .B(B),
        .result(result)
    );

    initial begin
        // Apply test cases
        A = 16'd1234;  // Example input 1 (4-digit number)
        B = 16'd4321;  // Example input 2 (4-digit number)

        #10;
        $display("A = %d, B = %d, Result = %d", A, B, result);

        // Test with another case
        A = 16'd1111;
        B = 16'd2222;

        #10;
        $display("A = %d, B = %d, Result = %d", A, B, result);

        // End the simulation
        #10;
        $finish;
    end
endmodule