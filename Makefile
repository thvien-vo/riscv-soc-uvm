TB    ?= tb_counter
RTL   := rtl/counter.sv
BUILD := build

drc:
	verilator --lint-only -Wall $(RTL)

build: drc
	mkdir -p $(BUILD)
	iverilog -g2012 -o $(BUILD)/sim.out $(RTL) tb/$(TB).sv

run: build
	cd $(BUILD) && vvp sim.out

wave:
	gtkwave $(BUILD)/dump.vcd &

clean:
	rm -rf $(BUILD)

.PHONY: drc build run wave clean
