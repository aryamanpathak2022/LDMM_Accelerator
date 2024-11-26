`timescale 1ns / 1ps

module top_controller(
    input   i_clk_100M,
            i_uart_rx,
            reset,
    
    output  [7:0] cathodes,
            [3:0] anodes
);

    localparam  N_DATA_BITS = 8,
                OVERSAMPLE = 13,
                BLOCK_RAM_SIZE = 10;
                
    localparam integer UART_CLOCK_DIVIDER = 64;
    localparam integer MAJORITY_START_IDX = 4;
    localparam integer MAJORITY_END_IDX = 8;
    localparam integer UART_CLOCK_DIVIDER_WIDTH = $clog2(UART_CLOCK_DIVIDER);
    
    reg uart_clk;
    reg uart_en;
    reg [UART_CLOCK_DIVIDER_WIDTH:0] uart_divider_counter;
    
    wire [N_DATA_BITS-1:0] uart_rx_data;
    wire uart_rx_data_valid;
    reg uart_rx_data_valid_delay;
    wire uart_rx_data_valid_pulse;
    
    reg [N_DATA_BITS-1:0] display_data;
    
    reg[5:0] write_counter;
    reg[3:0] ram_write_addr;
    reg[3:0] ram_read_addr;
    reg [31:0] ram_data_in;
    reg[5:0] counter;
    reg ram_we;
    reg read_mode;
    wire [31:0] ram_data_out0, ram_data_out1, ram_data_out2, ram_data_out3;
    wire ena;
    
    assign ena = 1;

    blk_mem_gen_0 ram0 (
        .clka(uart_clk),
        .ena(ena),
        .wea(ram_we && (write_counter[1:0] == 2'b00)),
        .addra(read_mode ? ram_read_addr : ram_write_addr),
        .dina(ram_data_in),
        .douta(ram_data_out0)
    );
      
    blk_mem_gen_1 ram1 (
        .clka(uart_clk),
        .ena(ena),
        .wea(ram_we && (write_counter[1:0] == 2'b01)),
        .addra(read_mode ? ram_read_addr : ram_write_addr),
        .dina(ram_data_in),
        .douta(ram_data_out1)
    );
    
    blk_mem_gen_2 ram2 (
        .clka(uart_clk),
        .ena(ena),
        .wea(ram_we && (write_counter[1:0] == 2'b10)),
        .addra(read_mode ? ram_read_addr : ram_write_addr),
        .dina(ram_data_in),
        .douta(ram_data_out2)
    );
    
    blk_mem_gen_3 ram3 (
        .clka(uart_clk),
        .ena(ena),
        .wea(ram_we && (write_counter[1:0] == 2'b11)),
        .addra(read_mode ? ram_read_addr : ram_write_addr),
        .dina(ram_data_in),
        .douta(ram_data_out3)
    );

    ila_0 input_monitor (
        .clk(uart_clk),
        .probe0(uart_rx_data_valid_pulse),
        .probe1(uart_rx_data),
        .probe2(i_uart_rx)
    );

    ila_1 ram_monitor (
        .clk(uart_clk),
        .probe0(counter),
        .probe1(ram_write_addr),
        .probe2(ram_read_addr),
        .probe3(read_mode),
        .probe4(ram_data_out1)
    );
    
    uart_rx #(
        .OVERSAMPLE(OVERSAMPLE),
        .N_DATA_BITS(N_DATA_BITS),
        .MAJORITY_START_IDX(MAJORITY_START_IDX),
        .MAJORITY_END_IDX(MAJORITY_END_IDX)
    ) rx_data (
        .i_clk(uart_clk),
        .i_en(uart_en),
        .i_reset(reset),
        .i_data(i_uart_rx),
        
        .o_data(uart_rx_data),
        .o_data_valid(uart_rx_data_valid)
    );
    
    seven_seg_drive #(
        .INPUT_WIDTH(N_DATA_BITS),
        .SEV_SEG_PRESCALAR(16)
    ) display (
        .i_clk(uart_clk),
        .number(display_data),
        .decimal_points(4'h0),
        .anodes(anodes),
        .cathodes(cathodes)
    );
    
    clk_wiz_0 clock_gen (
        .clk_out1(uart_clk),
        .clk_in1(i_clk_100M)
    );


    // block ram for c(output)
// blk_mem_gen_4 c1 (
//   .clka(clk),    // input wire clka
//   .ena(ena),      // input wire ena
//   .wea(wea),      // input wire [0 : 0] wea
//   .addra(addra),  // input wire [3 : 0] addra
//   .dina(dina),    // input wire [31 : 0] dina
//   .douta()  // output wire [31 : 0] douta
// );

// blk_mem_gen_5 c2 (
//   .clka(clk),    // input wire clka
//   .ena(ena),      // input wire ena
//   .wea(wea),      // input wire [0 : 0] wea
//   .addra(addra),  // input wire [3 : 0] addra
//   .dina(dina),    // input wire [31 : 0] dina
//   .douta()  // output wire [31 : 0] douta
// );

// blk_mem_gen_6 c3 (
//   .clka(clk),    // input wire clka
//   .ena(ena),      // input wire ena
//   .wea(wea),      // input wire [0 : 0] wea
//   .addra(addra),  // input wire [3 : 0] addra
//   .dina(dina),    // input wire [31 : 0] dina
//   .douta()  // output wire [31 : 0] douta
// );

// blk_mem_gen_7 c4 (
//   .clka(clk),    // input wire clka
//   .ena(ena),      // input wire ena
//   .wea(wea),      // input wire [0 : 0] wea
//   .addra(addra),  // input wire [3 : 0] addra
//   .dina(dina),    // input wire [31 : 0] dina
//   .douta()  // output wire [31 : 0] douta
// );


wire [31:0] c00;
wire [31:0] c01;
wire [31:0] c02;
wire [31:0] c03;
wire [31:0] c10;
wire [31:0] c11;
wire [31:0] c12;
wire [31:0] c13;
wire [31:0] c20;
wire [31:0] c21;
wire [31:0] c22;
wire [31:0] c23;
wire [31:0] c30;
wire [31:0] c31;
wire [31:0] c32;
wire [31:0] c33;



 systolic_matrix_mul_4x4 multiplier (
    .clk(uart_clk),
    .rst(reset),

    // Map each element of matrix A to the appropriate inputs
    .a_0(ram_data_out0),
    .a_1(ram_data_out1),
    .a_2(ram_data_out2),
    .a_3(ram_data_out3),

    // Map each element of matrix B to the appropriate inputs
    .b_0(ram_data_out0),
    .b_1(ram_data_out1),
    .b_2(ram_data_out2),
    .b_3(ram_data_out3),
    .flag(read_mode),

    // Connect each element of the output matrix C individually
    .c_00(c00),
    .c_01(c01),
    .c_02(c02),
    .c_03(c03),
    .c_10(c10),
    .c_11(c11),
    .c_12(c12),
    .c_13(c13),
    .c_20(c20),
    .c_21(c21),
    .c_22(c22),
    .c_23(c23),
    .c_30(c30),
    .c_31(c31),
    .c_32(c32),
    .c_33(c33)
);


ila_4 monitor_debug (
	.clk(uart_clk), // input wire clk


	.probe0(ram_data_out0), // input wire [31:0]  probe0  
	.probe1(ram_data_out1), // input wire [31:0]  probe1 
	.probe2(ram_data_out2), // input wire [31:0]  probe2 
	.probe3(ram_data_out3), // input wire [31:0]  probe3 
	.probe4(c00), // input wire [31:0]  probe4
	.probe5(read_mode)
);



ila_2 final_monitor (
	.clk(uart_clk), // input wire clk


	.probe0(c00), // input wire [31:0]  probe0  
	.probe1(c01), // input wire [31:0]  probe1 
	.probe2(c02), // input wire [31:0]  probe2 
	.probe3(c03) // input wire [31:0]  probe3
);
    


    always @(posedge uart_clk) begin
        if (reset)
            uart_rx_data_valid_delay <= 0;
        else
            uart_rx_data_valid_delay <= uart_rx_data_valid;
    end
    
    always @(posedge uart_clk) begin
        if(uart_divider_counter < (UART_CLOCK_DIVIDER-1))
            uart_divider_counter <= uart_divider_counter + 1;
        else
            uart_divider_counter <= 'd0;
    end
    
    assign uart_rx_data_valid_pulse = uart_rx_data_valid && !uart_rx_data_valid_delay;
    
    always @(posedge uart_clk) begin
        uart_en <= (uart_divider_counter == 'd10); 
    end
    
    // Main control logic
    always @(posedge uart_clk) begin
        if (reset) begin
            write_counter <= 0;
            ram_write_addr <= 0;
            ram_read_addr <= 0;
            counter <= 0;
            ram_we <= 0;
            read_mode <= 0;
        end
        else if (!read_mode) begin // Write mode
            if (counter == 4) begin // After filling all RAMs
                read_mode <= 1;
            end
            if (uart_rx_data_valid_pulse) begin
                ram_data_in <= uart_rx_data;
                ram_we <= 1'b1;
                
                if (ram_write_addr == BLOCK_RAM_SIZE - 1) begin
                    ram_write_addr <= 0;
                    counter <= counter + 1;
                    write_counter <= write_counter + 1;
                end
                else begin
                    ram_write_addr <= ram_write_addr + 1;
                end
            end
            else begin
                ram_we <= 1'b0;
            end
        end
        else begin // Read mode
            ram_we <= 1'b0;
            if (ram_read_addr == BLOCK_RAM_SIZE - 1) begin
//                ram_read_addr <= 0;
                read_mode <= 1'b0;
                counter <= 10;
            end
            else
                ram_read_addr <= ram_read_addr + 1;
        end
    end
    
    always @(posedge uart_clk) begin
        if (reset)
            display_data <= 0;
        else if (!read_mode && uart_rx_data_valid)
            display_data <= uart_rx_data;
    end
endmodule
