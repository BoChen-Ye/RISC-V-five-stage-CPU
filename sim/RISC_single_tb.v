`timescale 1ns / 1ps

module RISC_single_tb();

reg         clk;
reg         reset;
  
wire [31:0] WriteData, DataAdr;
wire 		MemWrite;

// instantiate device to be tested
Top dut(
	.clk(clk),
	.reset(reset),
	
	.WriteData(WriteData),
	.DataAdr(DataAdr),
	.MemWrite(MemWrite)
);
  
// initialize test
initial
  begin
    reset <= 1; 
	# 22; 
	reset <= 0;
end

// generate clock to sequence tests
always
  begin
    clk <= 1; 
	# 5; 
	clk <= 0; 
	# 5;
end

// check that 25 gets written to address 100
always@(negedge clk)
  begin
    if(MemWrite) begin
      if(DataAdr === 100 & WriteData === 25) begin
        $display("Simulation succeeded");
        $stop;
      end else if (DataAdr !== 96) begin
        $display("Simulation failed");
        $stop;
      end
    end
  end

endmodule