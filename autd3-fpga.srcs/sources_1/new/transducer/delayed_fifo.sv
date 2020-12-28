/*
 * File: delayed_fifo.sv
 * Project: new
 * Created Date: 16/12/2020
 * Author: Shun Suzuki
 * -----
 * Last Modified: 16/12/2020
 * Modified By: Shun Suzuki (suzuki@hapis.k.u-tokyo.ac.jp)
 * -----
 * Copyright (c) 2020 Hapis Lab. All rights reserved.
 * 
 */

`timescale 1ns / 1ps

module delayed_fifo#(
           parameter WIDTH = 8,
           parameter DEPTH_RADIX = 8
       )(
           input var CLK,
           input var [7:0] DELAY,
           input var [WIDTH-1:0] DATA_IN,
           output var [WIDTH-1:0] DATA_OUT
       );

localparam DEPTH = 1 << DEPTH_RADIX;

logic [WIDTH-1:0] mem[0:DEPTH-1] = '{DEPTH{0}};
logic [DEPTH_RADIX-1:0] ptr = 0;
logic [WIDTH-1:0] data_out = 0;
logic [7:0] delay = 0;

assign DATA_OUT = (DELAY == 8'd0) ? DATA_IN : data_out;

always_ff @(posedge CLK) begin
    mem[ptr] <= DATA_IN;
    delay <= DELAY;
    ptr <= (ptr + 1 < delay) ? ptr + 1 : 0;
end

always_comb begin
    data_out = mem[ptr];
end

endmodule