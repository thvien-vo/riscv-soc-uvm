TB    ?= tb_counter
TOP   ?= counter
SIM   ?= verilator
FLIST := rtl/rtl.f
BUILD := build

drc:
	verilator --lint-only -Wall -Wno-MULTITOP -f $(FLIST)

ifeq ($(SIM),verilator)             
build: drc
	mkdir -p $(BUILD)
	verilator --binary --trace --timescale 1ps/1ps -Wno-fatal \
	    --top-module $(TB) -Mdir $(BUILD)/obj_dir -o sim \
	    -f $(FLIST) tb/$(TB).sv

run: build
	cd $(BUILD) && ./obj_dir/sim | tee sim.log
else                                
build: drc
	mkdir -p $(BUILD)
	iverilog -g2012 -s $(TB) -o $(BUILD)/sim.out -f $(FLIST) tb/$(TB).sv

run: build
	cd $(BUILD) && vvp sim.out | tee sim.log
endif

wave:
	gtkwave $(BUILD)/dump.vcd &

schem:
	mkdir -p $(BUILD)
	yosys -q -p "read_verilog -sv $(shell cat $(FLIST)); prep -top $(TOP); write_json $(BUILD)/$(TOP).json"
	netlistsvg $(BUILD)/$(TOP).json -o $(BUILD)/$(TOP).svg
	xdg-open $(BUILD)/$(TOP).svg

clean:
	rm -rf $(BUILD)

.PHONY: drc build run wave schem clean
