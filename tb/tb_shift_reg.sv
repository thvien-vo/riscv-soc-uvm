`timescale 1ps/1ps

module tb_shift_reg;
localparam W = 4;
localparam D = 3;

logic clk;
logic rst_n;
logic en;
logic [W-1:0] d;
logic [W-1:0] q;
int errors = 0;

shift_reg #(.WIDTH(W), .DEPTH(D)) dut (
    .clk(clk),
    .rst_n(rst_n),
    .en(en),
    .d(d),
    .q(q)
);

task automatic check_shift (
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
    $dumpvars(0, tb_shift_reg);

    rst_n = 1'b0;
    en = 1'b0;
    d = '0;

    repeat (2) @(posedge clk);

    @(negedge clk);
    check_shift(4'h0, "Row 0");
    rst_n = 1;

    if (errors == 0) $display("TEST PASSED");
    else $display("TEST FAILED %0d error(s)", errors);

    $finish;
end

endmodule
