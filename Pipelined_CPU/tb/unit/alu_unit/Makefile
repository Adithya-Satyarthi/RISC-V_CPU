TOPLEVEL_LANG = verilog
VERILOG_SOURCES = $(abspath ../../../src/alu_unit.v)
TOPLEVEL = alu_unit
MODULE = tb_alu_unit

SIM = icarus

include $(shell cocotb-config --makefiles)/Makefile.sim

clean::
	rm -rf __pycache__ .sim_build *.xml