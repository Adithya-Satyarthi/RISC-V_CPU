import cocotb
from cocotb.triggers import Timer
import random

def alu_model(a, b, ctrl):
    
    a = a & 0xFFFFFFFF
    b = b & 0xFFFFFFFF

    def to_signed(x):
        return x if x < (1 << 31) else x - (1 << 32)

    signed_a = to_signed(a)
    signed_b = to_signed(b)

    unsigned_a = a
    unsigned_b = b

    shift = b & 0b11111

    if ctrl == 0:  # ADD
        result = signed_a + signed_b
    elif ctrl == 1:  # SUB
        result = signed_a - signed_b
    elif ctrl == 2:  # AND
        result = a & b
    elif ctrl == 3:  # OR
        result = a | b
    elif ctrl == 4:  # XOR
        result = a ^ b
    elif ctrl == 5:  # SLT
        result = int(signed_a < signed_b)
    elif ctrl == 6:  # SLTU
        result = int(unsigned_a < unsigned_b)
    elif ctrl == 7:  # SLL
        result = (a << shift) & 0xFFFFFFFF
    elif ctrl == 8:  # SRL
        result = unsigned_a >> shift
    elif ctrl == 9:  # SRA
        result = signed_a >> shift
    else:
        result = 0

    return result & 0xFFFFFFFF

@cocotb.test()
async def alu_test(dut):

    # random testing
    for ctrl in range(10):
        for t in range(100):
            a = random.randint(0, 0xFFFFFFFF)
            b = random.randint(0, 0xFFFFFFFF)

            # Apply inputs
            dut.operand_a.value = a
            dut.operand_b.value = b
            dut.alu_control.value = ctrl

            await Timer(2, units="ns")  # wait for a few ns

            expected = alu_model(a, b, ctrl)
            actual = dut.alu_result.value.integer

            bit_width = 32
            expected = format(expected & (2**bit_width - 1), f'0{8}x')
            actual = format(actual, f'0{8}x')

            cocotb.log.info(f"{a=} {b=} {ctrl=} expected=0x{expected}, got=0x{actual}")
            assert actual == expected, f"Mismatch: {a=} {b=} {ctrl=} expected={expected}, got={actual}"




