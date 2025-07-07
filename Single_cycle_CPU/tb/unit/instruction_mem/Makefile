TOPLEVEL_LANG = verilog
SIM = icarus
TOPLEVEL = instruction_mem
MODULE = tb_instr_mem

SRC := $(abspath ../../../src)

VERILOG_SOURCES = $(SRC)/instruction_mem.v


include $(shell cocotb-config --makefiles)/Makefile.sim

clean::
	rm -rf __pycache__ .sim_build *.xml