`timescale 1ns / 1ps

module Top(
	input 		  clk,reset,
	
	output [31:0] WriteData,DataAdr,
	output 		  MemWrite
);

wire [31:0] PC,Instr,ReadData;

//instantiate processor and memories
RISCVsingle rvsingle(
	.clk(clk),
	.reset(reset),
    .Instr(Instr),
    .ReadData(ReadData),
    
    .PC(PC),
    .MemWrite(MemWrite),
    .ALUResult(DataAdr),
	.WriteData(WriteData)
);
Imem imem(
	.a(PC),
	
	.rd(Instr)
);
Dmem dmem(
	.clk(clk), 
	.we(MemWrite),
    .a(DataAdr), 
	.wd(WriteData),
    
    .rd(ReadData)
);

endmodule