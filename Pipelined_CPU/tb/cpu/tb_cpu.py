import cocotb
from cocotb.triggers import RisingEdge
from cocotb.clock import Clock #type: ignore

@cocotb.test()
async def tb_pipe_cpu(dut):
    clock = Clock(dut.clk, 10, units = "ns")
    cocotb.start_soon(clock.start())

    dut.reset.value = 1
    await RisingEdge(dut.clk)
    dut.reset.value = 0

    for _ in range(500):
        await RisingEdge(dut.clk)


    # --- Validate Memory Contents ---

    expected_memory = {
        0x00: 30,      # add
        0x04: 10,      # sub
        0x08: 320,     # sll
        0x0C: 1,       # slt
        0x10: 1,       # sltu
        0x14: 0xFFFFFFF0,  # xor
        0x18: 0,       # srl
        0x1C: -1 & 0xFFFFFFFF, # sra
        0x20: 15,      # or
        0x24: 10,      # and
        0x28: 125,     # addi
        0x2C: 800,     # slli
        0x30: 0,       # slti
        0x34: 0,       # sltiu
        0x38: (-2048 ^ 2047) & 0xFFFFFFFF, # xori
        0x3C: 25,      # srli
        0x40: -25 & 0xFFFFFFFF, # srai
        0x44: 111,     # ori
        0x48: 0,       # andi
        0x50: 1234,    # sw test 1
        0x54: 1000,    # sw test 2
    }

    for addr, expected in expected_memory.items():
        actual = int(dut.dataMem.memory[addr // 4].value)
        dut._log.info(F"{actual= :<10}, {expected= :<10}")
        assert actual == expected, f"Memory[{hex(addr)}] = {actual}, expected {expected}"

    # --- Validate Register Values ---

    expected_registers = {
        23: 432,       # x23 = result of BEQ test
        24: 111,       # x24 = after JAL return
        25: 333,       # x25 = set inside subroutine
    }

    for reg, expected in expected_registers.items():
        actual = int(dut.registerFile.registers[reg].value)
        dut._log.info(F"{actual= :<10}, {expected= :<10}")
        assert actual == expected, f"x{reg} = {actual}, expected {expected}"

    dut._log.info("CPU memory and register state verified successfully.")

