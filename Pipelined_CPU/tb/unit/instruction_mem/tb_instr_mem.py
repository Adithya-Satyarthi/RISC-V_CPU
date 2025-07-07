import cocotb
from cocotb.clock import Clock
from cocotb.triggers import Timer

@cocotb.test()
async def tb_cpu(dut):

    logger = dut._log

    with open("instruction.txt", "r") as file:
        expected_values = [line.strip() for line in file]

    for i in range(1024):
        addr = 4*i & 0xFFFFFFFF
        dut.address.value = addr
        await Timer(10, units='ns')
        result = dut.instruction.value.integer

        result = f"{result:08x}"
        expected = expected_values[i]
        logger.info(f'Output is: {result}, Expected is: {expected}')
        #assert result == expected, f'Output is: {result}, Expected is: {expected}'
