`timescale 1ns / 1ps

module ALU(
	input [31:0] A,B,
	input [2:0]  ALUControl,
	
	output		 Zero,
	output reg [31:0] Result
);

wire [31:0] temp1,Sum;
wire		V,slt; //overflow

assign temp1 = ALUControl[0] ? ~B:B;
assign Sum   = A + temp1 + ALUControl[0];
assign V	 = ((~ALUControl[1]) & (A[31]^Sum[31]) & (~ALUControl[0]^A[31]^B[31]));
assign slt	 = V^Sum[31];

always@(*)
  case(ALUControl)
	3'b000: Result <= Sum; //add
	3'b001: Result <= Sum; //sub
	3'b010: Result <= A&B; //and
	3'b011: Result <= A|B; //or
	3'b101: Result <= {31'b0,slt}; //slt
  endcase

assign Zero = (Result == 32'b0);

endmodule