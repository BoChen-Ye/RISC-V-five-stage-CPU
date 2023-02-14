`timescale 1ns / 1ps

module Datapath(
	input 		 clk,reset,
	input [1:0]  ResultSrc,
	input 		 PCSrc,ALUSrc,
	input 		 RegWrite,
	input [1:0]  ImmSrc,
	input [2:0]  ALUControl,
	input [31:0] Instr,
	input [31:0] ReadData,
	
	output 		  Zero,
	output [31:0] PC,
	output [31:0] ALUResult,WriteData
);

wire [31:0] PCnext,PCplus4,PCtarget;
wire [31:0] ImmExt;
wire [31:0] SrcA,SrcB;
wire [31:0] Result;

//next PC logic
Flopr #(32) PCreg(
	.clk(clk),
	.reset(reset),
	.d(PCnext),
	
	.q(PC)
);
Adder PCadd4(
	.a(PC),
	.b(32'd4),
	
	.out(PCplus4)
);
Adder PCaddBranch(
	.a(PC),
	.b(ImmExt),
	
	.out(PCtarget)
);
Mux2 #(32) PCmux(
	.d0(PCplus4),
	.d1(PCtarget),
	.sel(PCSrc),
	
	.out(PCnext)
);

//register file logic
Regfile rf(
	.clk(clk),
	.we3(RegWrite),
    .ra1(Instr[19:15]),
	.ra2(Instr[24:20]),
	.wa3((Instr[11:7])),
    .wd3(Result),
	
    .rd1(SrcA),
    .rd2(WriteData)
);
Extend ext(
	.instr(Instr[31:7]),
	.immsrc(ImmSrc),
    
    .immext(ImmExt)
); 

//ALU logic
Mux2 #(32) Srcmux(
	.d0(WriteData),
	.d1(ImmExt),
	.sel(ALUSrc),
	
	.out(SrcB)
);
ALU alu(
	.A(SrcA),
	.B(SrcB),
    .ALUControl(ALUControl),
    
    .Zero(Zero),
    .Result(ALUResult)
);
Mux3 #(32) resultmux(
	.d0(ALUResult),
	.d1(ReadData),
	.d2(PCplus4),
    .sel(ResultSrc),
    
    .out(Result)
);

endmodule


