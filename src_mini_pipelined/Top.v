`timescale 1ns / 1ps

module Top(
	input 		  clk,reset,
	
	output [31:0] WriteDataM,DataAdrM,
	output 		  MemWriteM
);

wire [31:0] PCF,InstrF,ReadDataM;

//instantiate processor and memories
miniRISCVpipe rvpipe(
	.clk(clk),
	.reset(reset),
    .InstrF(InstrF),
    .ReadDataM(ReadDataM),
    
    .PCF(PCF),
    .MemWriteM(MemWriteM),
    .ALUResultM(DataAdrM),
	.WriteDataM(WriteDataM)
);
Imem imem(
	.a(PCF),
	
	.rd(InstrF)
);
Dmem dmem(
	.clk(clk), 
	.we(MemWriteM),
    .a(DataAdrM), 
	.wd(WriteDataM),
    
    .rd(ReadDataM)
);

endmodule