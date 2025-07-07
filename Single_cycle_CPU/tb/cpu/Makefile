TOPLEVEL_LANG = verilog
SIM = icarus
TOPLEVEL = cpu
MODULE = tb_cpu

SRC := $(abspath ../../src)
INSTR_FILE := $(SRC)/instruction.txt

VERILOG_SOURCES = $(SRC)/cpu_top_module.v \
                  $(SRC)/alu_unit.v \
                  $(SRC)/register_file.v \
                  $(SRC)/control_unit.v \
                  $(SRC)/data_mem.v \
                  $(SRC)/instruction_mem.v \
                  $(SRC)/imm_gen.v \
                  $(SRC)/program_counter.v \
                  $(SRC)/alu_control_unit.v


include $(shell cocotb-config --makefiles)/Makefile.sim

clean::
	rm -rf __pycache__ .sim_build *.xml