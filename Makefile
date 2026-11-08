TB    ?= tb_counter
TOP   ?= counter
FLIST := rtl/rtl.f
BUILD := build

drc:
	verilator --lint-only -Wall -Wno-MULTITOP -f $(FLIST)

build: drc
	mkdir -p $(BUILD)
	iverilog -g2012 -s $(TB) -o $(BUILD)/sim.out -f $(FLIST) tb/$(TB).sv

run: build
	cd $(BUILD) && vvp sim.out | tee sim.log

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
