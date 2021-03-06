`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 12/20/2020 05:51:44 PM
// Design Name:
// Module Name: sim_transducers_array
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module sim_transducers_array();

logic MRCC_25P6M;
logic MRCC_12P8M;

logic [9:0] time_cnt;
logic [7:0] DUTY [0:1];
logic [7:0] PHASE [0:1];
logic [7:0] MOD;
logic [252:1] XDCR_OUT;

transducers_array#(.TRANS_NUM(2))
                 transducers_array(
                     .CLK(MRCC_25P6M),
                     .CLK_LPF(MRCC_12P8M),
                     .TIME(time_cnt),
                     .DUTY,
                     .PHASE,
                     .MOD,
                     .SILENT(1'b0),
                     .XDCR_OUT
                 );

assign tr1 = XDCR_OUT[1];
assign tr2 = XDCR_OUT[2];

initial begin
    MRCC_25P6M = 0;
    MRCC_12P8M = 0;
    time_cnt = 0;
    DUTY = {8'hFF, 8'hFF};
    PHASE = {8'h34, 8'h34};
    MOD = 8'hFF;

    #1000000;
    DUTY = {8'h32, 8'h32};
    PHASE = {8'h0, 8'h34};
end

// main clock 25.6MHz
always @(posedge MRCC_25P6M) begin
    time_cnt = (time_cnt == 10'd639) ? 0 : time_cnt + 1;
end

// main clock 25.6MHz
always begin
    #19.531 MRCC_25P6M = !MRCC_25P6M;
    #19.531 MRCC_25P6M = !MRCC_25P6M;
    #19.531 MRCC_25P6M = !MRCC_25P6M;
    #19.532 MRCC_25P6M = !MRCC_25P6M;
end

always @(posedge MRCC_25P6M) begin
    MRCC_12P8M = ~MRCC_12P8M;
end

endmodule
