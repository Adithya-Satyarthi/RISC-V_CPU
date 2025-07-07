TOPLEVEL_LANG = verilog
SIM = icarus
VERILOG_SOURCES = $(abspath ../../../src/data_mem.v)
TOPLEVEL = data_mem
MODULE = tb_data_mem

include $(shell cocotb-config --makefiles)/Makefile.sim

clean::
	rm -rf __pycache__ .sim_build *.xml