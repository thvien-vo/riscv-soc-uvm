TB    ?= tb_counter
RTL   := rtl/counter.sv
BUILD := build

lint:
	verilator --lint-only -Wall $(RTL)

sim: lint
	mkdir -p $(BUILD)
	iverilog -g2012 -o $(BUILD)/sim.out $(RTL) tb/$(TB).sv
	cd $(BUILD) && vvp sim.out

wave:
	gtkwave $(BUILD)/dump.vcd &

clean:
	rm -rf $(BUILD)

.PHONY: lint sim wave clean
