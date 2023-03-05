`timescale 1ns / 1ps

module Datapath(
	input 		 clk,reset,
	input [1:0]  ResultSrcW,
	input 		 PCSrcE,ALUSrcE,
	input 		 RegWriteM,RegWriteW,
	input [1:0]  ImmSrcD,
	input [2:0]  ALUControlE,
	input [31:0] InstrF,
	input [31:0] ReadDataM,
	input [1:0]  ResultSrcE,
	
	output 		  ZeroE,
	output [31:0] InstrD,
	output		  flushE,
	output [31:0] PCF,
	output [31:0] ALUResultM,WriteDataM
);

wire [1:0]  forwardAE, forwardBE;
wire 		stallD,stallF;
wire [4:0]  Rs1D, Rs2D, Rs1E, Rs2E, RdM, RdW, RdE,RdD;
wire 		flushD;
wire [31:0] PCnextF;
wire [31:0] PCplus4F,PCplus4D,PCplus4E,PCplus4M,PCplus4W;
wire [31:0] PCD,PCE;
wire [31:0] PCtargetE;
wire [31:0] RD1D,RD2D,RD1E,RD2E;
wire [31:0] ImmExtD,ImmExtE;
wire [31:0] SrcAE,SrcBE;
wire [31:0] ALUResultE,ALUResultW,WriteDataE,ReadDataW;
wire [31:0] ResultW;

//Fetch stage
Mux2 #(32) PCmux(
	.d0(PCplus4F),
	.d1(PCtargetE),
	.sel(PCSrcE),
	
	.out(PCnextF)
);
Flopenr #(32) PCreg(
	.clk(clk),
	.reset(reset),
	.en(~stallF),
	.d(PCnextF),
	
	.q(PCF)
);
Adder PCadd4(
	.a(PCF),
	.b(32'd4),
	
	.out(PCplus4F)
);
//Decode stage
Flopenr #(32) r1D(
	.clk(clk), 
	.reset(reset), 
	.en(~stallD), 
	.d(PCplus4F), 
	
	.q(PCplus4D)
);
Flopenrc #(32) r2D(
	.clk(clk), 
	.reset(reset), 
	.en(~stallD), 
	.clear(flushD), 
	.d(InstrF),
	
	.q(InstrD)
);
Flopenrc #(32) r3D(
	.clk(clk), 
	.reset(reset), 
	.en(~stallD), 
	.clear(flushD), 
	.d(PCF),
	
	.q(PCD)
);

Regfile rf(
	.clk(clk),
	.we3(RegWriteW),
    .ra1(InstrD[19:15]),
	.ra2(InstrD[24:20]),
	.wa3(RdW),
    .wd3(ResultW),
	
    .rd1(RD1D),
    .rd2(RD2D)
);
Extend ext(
	.instr(InstrD[31:7]),
	.immsrc(ImmSrcD),
    
    .immext(ImmExtD)
);
assign Rs1D = InstrD[19:15];
assign Rs2D = InstrD[24:20];
assign RdD = InstrD[11:7];

//Execute stage
Floprc #(32) r1E(
	.clk(clk), 
	.reset(reset),  
	.clear(flushE), 
	.d(RD1D),
	
	.q(RD1E)
);
Floprc #(32) r2E(
	.clk(clk), 
	.reset(reset),  
	.clear(flushE), 
	.d(RD2D),
	
	.q(RD2E)
);
Floprc #(32) r3E(
	.clk(clk), 
	.reset(reset),  
	.clear(flushE), 
	.d(PCD),
	
	.q(PCE)
);
Floprc #(32) r4E(
	.clk(clk), 
	.reset(reset),  
	.clear(flushE), 
	.d(Rs1D),
	
	.q(Rs1E)
);
Floprc #(32) r5E(
	.clk(clk), 
	.reset(reset),  
	.clear(flushE), 
	.d(Rs2D),
	
	.q(Rs2E)
);
Floprc #(32) r6E(
	.clk(clk), 
	.reset(reset),  
	.clear(flushE), 
	.d(RdD),
	
	.q(RdE)
);
Floprc #(32) r7E(
	.clk(clk), 
	.reset(reset),  
	.clear(flushE), 
	.d(ImmExtD),
	
	.q(ImmExtE)
);
Floprc #(32) r8E(
	.clk(clk), 
	.reset(reset),  
	.clear(flushE), 
	.d(PCplus4D),
	
	.q(PCplus4E)
);
Mux3 #(32) SrcAmux(
	.d0(RD1E),
	.d1(ResultW),
	.d2(ALUResultM),
    .sel(forwardAE),
    
    .out(SrcAE)
);
Mux3 #(32) SrcBmux(
	.d0(RD2E),
	.d1(ResultW),
	.d2(ALUResultM),
    .sel(forwardBE),
    
    .out(WriteDataE)
);
Adder PCaddBranch(
	.a(PCE),
	.b(ImmExtE),
	
	.out(PCtargetE)
);
Mux2 #(32) Srcmux(
	.d0(WriteDataE),
	.d1(ImmExtE),
	.sel(ALUSrcE),
	
	.out(SrcBE)
);
ALU alu(
	.A(SrcAE),
	.B(SrcBE),
    .ALUControl(ALUControlE),
    
    .Zero(ZeroE),
    .Result(ALUResultE)
);
//Memory stage
Flopr #(32) r1M(
	.clk(clk), 
	.reset(reset), 
	.d(ALUResultE), 
	
	.q(ALUResultM)
);
Flopr #(32) r2M(
	.clk(clk), 
	.reset(reset), 
	.d(WriteDataE), 
	
	.q(WriteDataM)
);
Flopr #(32) r3M(
	.clk(clk), 
	.reset(reset), 
	.d(RdE), 
	
	.q(RdM)
);
Flopr #(32) r4M(
	.clk(clk), 
	.reset(reset), 
	.d(PCplus4E), 
	
	.q(PCplus4M)
);

//Writeback stage
Flopr #(32) r1W(
	.clk(clk), 
	.reset(reset), 
	.d(ALUResultM), 
	
	.q(ALUResultW)
);
Flopr #(32) r2W(
	.clk(clk), 
	.reset(reset), 
	.d(ReadDataM), 
	
	.q(ReadDataW)
);
Flopr #(32) r3W(
	.clk(clk), 
	.reset(reset), 
	.d(RdM), 
	
	.q(RdW)
);
Flopr #(32) r4W(
	.clk(clk), 
	.reset(reset), 
	.d(PCplus4M), 
	
	.q(PCplus4W)
);
Mux3 #(32) resultmux(
	.d0(ALUResultW),
	.d1(ReadDataW),
	.d2(PCplus4W),
    .sel(ResultSrcW),
    
    .out(ResultW)
);
//hazard detection
Hazard H(
	.Rs1D(Rs1D), 
	.Rs2D(Rs2D), 
	.Rs1E(Rs1E), 
	.Rs2E(Rs2E), 
	.RdM(RdM), 
	.RdW(RdW), 
	.RdE(RdE),
	.RegwriteM(RegWriteM), 
	.RegwriteW(RegWriteM),
	.ResultSrcE(ResultSrcE),
	.PCSrcE(PCSrcE),

	.forwardAE(forwardAE), 
	.forwardBE(forwardBE),
	.stallF(stallF), 
	.stallD(stallD), 
	.flushD(flushD), 
	.flushE(flushE)	
);

endmodule


