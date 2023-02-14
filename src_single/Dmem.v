`timescale 1ns / 1ps

module Dmem(
	input         clk, we,
    input  [31:0] a, wd,
	
    output [31:0] rd
);

reg  [31:0] RAM[63:0];

assign rd = RAM[a[31:2]]; // word aligned

always @(posedge clk)
  if (we)
    RAM[a[31:2]] <= wd;

endmodule