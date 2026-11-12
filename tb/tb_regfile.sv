// tb_regfile: self-checking testbench for regfile (reset, write/read, x0, enable)
// Author: Vo Nguyen Thanh Vien
`timescale 1ps/1ps

module tb_regfile;
    import regfile_pkg::*;

logic clk;
logic rst_n;
wr_reg_t wr_reg;
logic [ADDR_W-1:0] rs1_addr;
logic [ADDR_W-1:0] rs2_addr;
logic [DATA_W-1:0] rs1_data;
logic [DATA_W-1:0] rs2_data;
int errors = 0;

regfile dut(
    .clk(clk),
    .rst_n(rst_n),
    .wr_reg(wr_reg),
    .rs1_addr(rs1_addr),
    .rs2_addr(rs2_addr),
    .rs1_data(rs1_data),
    .rs2_data(rs2_data)
);

task automatic check_reg(
    input logic [DATA_W-1:0] exp_rs1_data, exp_rs2_data, input string name
);
    if (exp_rs1_data !== rs1_data) begin
        $display("ERROR at %0t, %s: Expected rs1_data = %h, got %h", $time, name, exp_rs1_data, rs1_data);
        errors++;
    end
    if (exp_rs2_data !== rs2_data) begin
        $display("ERROR at %0t, %s: Expected rs2_data = %h, got %h", $time, name, exp_rs2_data, rs2_data);
        errors++;
    end
endtask //automatic

initial clk = 1'b0;
always #5 clk = ~clk;

initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, tb_regfile);

    rst_n = 1'b0;
    wr_reg = '0;
    rs1_addr = '0;
    rs2_addr = 5;

    repeat(2) @(posedge clk);

    @(negedge clk) check_reg('0, '0, "ROW 0: reset");
    rst_n = 1'b1;

    wr_reg.en = 1'b1;
    wr_reg.addr = 5;
    wr_reg.data = 32'h12345678;
    rs1_addr = 5;
    rs2_addr = 0;
    @(negedge clk) check_reg(32'h12345678, 32'h00000000, "ROW 1: en=1, write x5");

    wr_reg.en = 1'b1;
    wr_reg.addr = 10;
    wr_reg.data = 32'hCAFEBABE;
    rs1_addr = 5;
    rs2_addr = 10;
    @(negedge clk) check_reg(32'h12345678, 32'hCAFEBABE, "ROW 2: en=1, write x10");
    
    wr_reg.en = 1'b0;
    wr_reg.addr = 5;
    wr_reg.data = 32'hFFFFFFFF;
    rs1_addr = 5;
    rs2_addr = 10;
    @(negedge clk) check_reg(32'h12345678, 32'hCAFEBABE, "ROW 3: en=0 (no write)");

    wr_reg.en = 1'b1;
    wr_reg.addr = 0;
    wr_reg.data = 32'hDEADBEEF;
    rs1_addr = 0;
    rs2_addr = 5;
    @(negedge clk) check_reg(32'h00000000, 32'h12345678, "ROW 4: en=1, write x0");

    wr_reg.en = 1'b1;
    wr_reg.addr = 5;
    wr_reg.data = 32'h00000001;
    rs1_addr = 5;
    rs2_addr = 5;
    @(negedge clk) check_reg(32'h00000001, 32'h00000001, "ROW 5: en=1, overwrite x5");

    wr_reg.en = 1'b0;
    wr_reg.addr = '0;
    wr_reg.data = '0;
    rs1_addr = 10;
    rs2_addr = 31;
    @(negedge clk) check_reg(32'hCAFEBABE, 32'h00000000, "ROW 6: en=0, read x10 and x31");

    if (errors == 0) $display("TEST PASSED");
    else $display("TEST FAILED %0d error(s)", errors);
    $finish;
end

endmodule
