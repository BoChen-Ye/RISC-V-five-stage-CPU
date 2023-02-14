# RISC-V five stage CPU
This is a project based on the book "Digital design and computer architure RISC-V edition".
I use Verilog to build the RISC-V CPU with five stage pipeline.
## Document strcture
- `mips` have two verilog file about MIPS CPU which from the website `www.ddcabook.com`.
- `src_single` have all verilog file about single-cycle RISCV processor. This CPU is implemented as 32-bit RISC_V(RV32I) architecture. The instruction that this tiny CPU can run now are `add,addi,or,ori,and,andi,beq,slt,slti,sub,sw,lw,jal`.
- `sim` is simulation folder. The testbench file store in this folder. 
- `src_pipeline` is verilog file about RISC-V CPU with five stage pipeline, but it don't start.
- `result` have the screenshots of waveform result.
