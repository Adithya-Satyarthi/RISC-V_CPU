import cocotb
from cocotb.triggers import Timer, RisingEdge
import random

opcodes = [0b0110011, 0b0010011, 0b0000011, 0b0100011, 0b1100011, 0b1101111]

#control unit model
def control_unit_model(opcode):
    # jump, branch, mem_read_en, result_src[1:0], alu_op[1:0], mem_write_en, alu_src, reg_write_en
    if opcode == 0b0110011:  # R-Type
        return 0b0000010001
    elif opcode == 0b0010011:  # I-Type
        return 0b0000011011
    elif opcode == 0b0000011:  # lw
        return 0b0010100011
    elif opcode == 0b0100011:  # sw
        return 0b0000000110
    elif opcode == 0b1100011:  # beq
        return 0b0100001000
    elif opcode == 0b1101111:  # jal
        return 0b1001000001
    else:
        return 0b0000000000

@cocotb.test()
async def tb_control_unit(dut):
    logger = dut._log

    for t in range(200):

        opcode = random.choice(opcodes + [random.randint(0, 0b1111111)])
        dut.opcode.value = opcode

        await Timer(2, units="ns")

        expected = control_unit_model(opcode)

        actual = (
            (dut.jump.value << 9)
            | (dut.branch.value << 8)
            | (dut.mem_read_en.value << 7)
            | (dut.result_src.value << 5)
            | (dut.alu_op.value << 3)
            | (dut.mem_write_en.value << 2)
            | (dut.alu_src.value << 1)
            | dut.reg_write_en.value
        )

        assert actual == expected, (
            f"Mismatch for opcode {opcode:07b}: "
            f"Expected {expected:010b}, Got {actual:010b}"
        )

        logger.info(f"Opcode {opcode:07b} passed. Output: {actual:010b}")
