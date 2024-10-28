module karatsuba_mac_4digit (
    input [15:0] A,  // 4-digit decimal number (16-bit binary)
    input [15:0] B,  // 4-digit decimal number (16-bit binary)
    output reg [31:0] result
);
    // MAC intermediate values
    reg [7:0] A1, A0, B1, B0;
    reg [15:0] P1, P2, P3;
    reg [31:0] temp1, temp2, temp3;

    always @(*) begin
        // Divide each input number A and B into two halves
        A1 = A[15:8];  // Upper half of A
        A0 = A[7:0];   // Lower half of A
        B1 = B[15:8];  // Upper half of B
        B0 = B[7:0];   // Lower half of B

        // Perform the multiplications as per Karatsuba algorithm
        P1 = A1 * B1;               // Multiplication of upper halves
        P2 = A0 * B0;               // Multiplication of lower halves
        P3 = (A1 + A0) * (B1 + B0); // Multiplication of sum of halves

        // Use the MAC unit logic (accumulate results)
        temp1 = {P1, 16'b0};         // Shifted P1 to the upper part of the result
        temp2 = (P3 - P1 - P2) << 8; // Middle part result (shifted by 8 bits)
        temp3 = P2;                  // Lower part result

        // Accumulate the final result
        result = temp1 + temp2 + temp3;
    end
endmodule