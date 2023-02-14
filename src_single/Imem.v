`timescale 1ns / 1ps

module Imem(
	input  [31:0] a,
	
    output [31:0] rd
);

reg  [31:0] RAM[63:0];

initial
begin
	$readmemh("RISCVtest.txt",RAM);
end

assign rd = RAM[a[31:2]]; // word aligned

endmodule