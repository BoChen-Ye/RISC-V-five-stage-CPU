# RISC-V five stages CPU
This is a project based on the book "Digital design and computer architure RISC-V edition".
I use Verilog to build the RISC-V CPU with five stages pipeline.
## Document strcture
- `mips` have two verilog file about MIPS CPU which from the website `www.ddcabook.com`.
- `src_single` have all verilog file about single-cycle RISC-V processor. This CPU is implemented as 32-bit RISC-V(RV32I) architecture. The instruction that this tiny CPU can run now are `sw,lw,add,sub,and,or,slt,addi,ori,slti,beq,jal`.
- `sim` is simulation folder. The testbench file store in this folder. 
- `src_mini_pipeline` is verilog file about RISC-V CPU with five stages pipeline, and it can also run same basic instruction as single-cycle. I will expand architecture in the future to make it run all RV32I instruction.
- `result` have the screenshots of waveform result.
