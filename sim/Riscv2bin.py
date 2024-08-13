def reg_to_bin(reg):
    return format(int(reg[1:]), '05b')


def imm_to_bin(imm, bits):
    imm = int(imm)
    if imm < 0:
        imm = (1 << bits) + imm
    return format(imm, f'0{bits}b')


def assemble_r_type(inst, rd, rs1, rs2, funct3, funct7):
    opcode = '0110011'
    return funct7 + reg_to_bin(rs2) + reg_to_bin(rs1) + funct3 + reg_to_bin(rd) + opcode


def assemble_i_type(inst, rd, rs1, imm, funct3, opcode):
    return imm_to_bin(imm, 12) + reg_to_bin(rs1) + funct3 + reg_to_bin(rd) + opcode


def assemble_s_type(inst, parts, funct3, opcode):
    imm = parts[2].split('(')[0]
    rs2 = parts[1]
    rs1 = parts[2].split('(')[1].rstrip(')')
    imm_bin = imm_to_bin(imm, 12)
    return imm_bin[0:7] + reg_to_bin(rs2) + reg_to_bin(rs1) + funct3 + imm_bin[7:12] + opcode


def assemble_lw(inst, parts, funct3, opcode):
    imm = parts[2].split('(')[0]
    rd = parts[1]
    rs1 = parts[2].split('(')[1].rstrip(')')
    imm_bin = imm_to_bin(imm, 12)
    return imm_bin[0:12] + reg_to_bin(rs1) + funct3 + reg_to_bin(rd) + opcode


def assemble_instruction(instruction):
    parts = instruction.split()
    inst = parts[0]
    # print(parts)
    if inst == 'add':
        return assemble_r_type(inst, parts[1], parts[2], parts[3], '000', '0000000')
    elif inst == 'sub':
        return assemble_r_type(inst, parts[1], parts[2], parts[3], '000', '0100000')
    elif inst == 'addi':
        return assemble_i_type(inst, parts[1], parts[2], parts[3], '000', '0010011')
    elif inst == 'lw':
        return assemble_lw(inst, parts, '010', '0000011')
    elif inst == 'sw':
        return assemble_s_type(inst, parts, '010', '0100011')
    else:
        raise ValueError(f"Unsupported instruction: {inst}")


def main():
    instructions = [
        "addi x2 x0 5",
        "sw x7 84(x3)",
        "lw x2 96(x0)",
        "sub x7 x7 x2"
    ]
    hex_instructions = []
    for instr in instructions:
        bin_instr = assemble_instruction(instr)
        hex_instr = format(int(bin_instr, 2), '08x').upper()
        hex_instructions.append(hex_instr)
        print(f"{instr} -> {bin_instr} -> 0x{hex_instr}")

    with open('instruction.txt', 'w') as f:
        for hex_instr in hex_instructions:
            f.write(hex_instr + '\n')


if __name__ == "__main__":
    main()
