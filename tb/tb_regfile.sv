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

    @(negedge clk) check_reg('0, '0, "ROW 0");
    rst_n = 1'b1;


    if (errors == 0) $display("TEST PASSED");
    else $display("TEST FAILED %0d error(s)", errors);
    $finish;
end

endmodule
