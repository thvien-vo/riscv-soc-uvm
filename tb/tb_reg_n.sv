`timescale 1ps/1ps
module tb_reg_n;
localparam int W = 4;

logic clk;
logic rst_n;
logic en;
logic [W-1:0] d;
logic [W-1:0] q;
int errors = 0;

reg_n #(.WIDTH(W)) dut(
    .clk(clk),
    .rst_n(rst_n),
    .en(en),
    .d(d),
    .q(q)
);

task automatic check_reg(
    input logic [W-1:0] exp_q, input string name
);
    if (exp_q !== q) begin
        $display("ERROR at %0t: %s: Expected q = %h, got q = %h", $time, name, exp_q, q);
        errors++;
    end
endtask

initial clk = 1'b0;
always #5 clk = ~clk;

initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, tb_reg_n);

    rst_n = 1'b0;
    en = 1'b0;
    d = '0;

    repeat(2) @(posedge clk);

    @(negedge clk);
    check_reg(4'h0, "row 0");
    rst_n = 1'b1;

    @(negedge clk);
    en = 1'b1;
    d = 4'hA;
    @(negedge clk);
    check_reg(4'hA, "row 1");

    @(negedge clk);
    en = 1'b0;
    d = 4'h5;
    @(negedge clk);
    check_reg(4'hA, "row 2");

    @(negedge clk);
    en = 1'b1;
    d = 4'h5;
    @(negedge clk);
    check_reg(4'h5, "row 3");

    @(negedge clk);
    en = 1'b0;
    d = 4'hF;
    @(negedge clk);
    check_reg(4'h5, "row 4");

    if (errors == 0) $display("TEST PASSED");
    else $display("TEST FAILED %0d error(s)", errors);

    $finish;

end

endmodule
