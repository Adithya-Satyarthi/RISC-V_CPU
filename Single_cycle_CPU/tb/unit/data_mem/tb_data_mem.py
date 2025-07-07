import cocotb
from cocotb.triggers import RisingEdge, Timer
from cocotb.clock import Clock
import random

@cocotb.test()
async def test_data_mem(dut):

    cocotb.start_soon(Clock(dut.clk, 10, units="ns").start())

    # Initialize inputs
    dut.mem_read_en.value = 0
    dut.mem_write_en.value = 0
    dut.address.value = 0
    dut.write_data.value = 0

    await RisingEdge(dut.clk)

    async def write_mem(addr, data):
        dut.mem_write_en.value = 1
        dut.mem_read_en.value = 0
        dut.address.value = addr
        dut.write_data.value = data
        await RisingEdge(dut.clk)
        dut.mem_write_en.value = 0
        await RisingEdge(dut.clk)

    async def read_mem(addr):
        dut.mem_read_en.value = 1
        dut.mem_write_en.value = 0
        dut.address.value = addr
        await Timer(1, units="ns")  
        return dut.read_data.value.integer

    test_cases = {}
    for i in range(10):
        addr = random.randint(0, 1023) * 4  # word-aligned
        data = random.randint(0, 0xFFFFFFFF)
        test_cases[addr] = data
        await write_mem(addr, data)

    for addr, expected_data in test_cases.items():
        actual_data = await read_mem(addr)
        cocotb.log.info(f"Read at 0x{addr:08X} = 0x{actual_data:08X} (expected 0x{expected_data:08X})")
        assert actual_data == expected_data, f"Mismatch at addr 0x{addr:08X}: expected 0x{expected_data:08X}, got 0x{actual_data:08X}"

    unused_addr = 512 * 4  # assuming it's unused
    if unused_addr not in test_cases:
        val = await read_mem(unused_addr)
        cocotb.log.info(f"Read unwritten addr 0x{unused_addr:08X} = 0x{val:08X}")
        assert val == 0 or val == dut.read_data.value.integer, "Unexpected value at uninitialized memory"

