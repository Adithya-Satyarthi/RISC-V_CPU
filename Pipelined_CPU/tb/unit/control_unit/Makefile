TOPLEVEL_LANG = verilog
SIM = icarus
VERILOG_SOURCES = $(abspath ../../../src/control_unit.v)

TOPLEVEL = control_unit
MODULE = tb_control_unit

include $(shell cocotb-config --makefiles)/Makefile.sim

clean::
	rm -rf __pycache__ .sim_build *.xml