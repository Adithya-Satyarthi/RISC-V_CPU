TOPLEVEL_LANG = verilog
SIM = icarus
TOP_LEVEL = cpu
MODULE = tb_cpu

VERILOG_SOURCES = $(abspath ../../src/*.v)

include $(shell cocotb-config --makefiles)/Makefile.sim

clean::
	rm -rf __pycache__ .sim_build *.xml
