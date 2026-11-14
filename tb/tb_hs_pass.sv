// tb_hs_pass: self-checking testbench for hs_pass (valid/data forward, ready backward)
// Author: Vo Nguyen Thanh Vien
`timescale 1ps/1ps
module tb_hs_pass;
localparam W = 8;
int errors = 0;

hs_if #(.WIDTH(W)) link_in();
hs_if #(.WIDTH(W)) link_out();

hs_pass dut (
    .tx(link_out),
    .rx(link_in)
);

task automatic check_pass(
    input logic exp_valid,
    input logic [W-1:0] exp_data,
    input logic exp_ready,
    input string name
);
    
    if (link_out.valid !== exp_valid) begin
        $display("ERROR at %0t, %s: Expected link_out.valid = %b, got %b",
                 $time, name, exp_valid, link_out.valid);
        errors++;
    end
    if (link_out.data !== exp_data) begin
        $display("ERROR at %0t, %s: Expected link_out.data = %h, got %h",
                 $time, name, exp_data, link_out.data);
        errors++;
    end
    if (link_in.ready !== exp_ready) begin
        $display("ERROR at %0t, %s: Expected link_in.ready = %b, got %b",
                 $time, name, exp_ready, link_in.ready);
        errors++;
    end

endtask //automatic

initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, tb_hs_pass);

    // ROW 1
    link_in.valid  = 1'b1;
    link_in.data   = 8'hA5;
    link_out.ready = 1'b0;
    #1;
    check_pass(1'b1, 8'hA5, 1'b0, "ROW 1");

    // ROW 2
    link_in.valid  = 1'b0;
    link_in.data   = 8'h3C;
    link_out.ready = 1'b1;
    #1;
    check_pass(1'b0, 8'h3C, 1'b1, "ROW 2");

    // ROW 3
    link_in.valid  = 1'b1;
    link_in.data   = 8'hFF;
    link_out.ready = 1'b1;
    #1;
    check_pass(1'b1, 8'hFF, 1'b1, "ROW 3");

    if (errors == 0) $display("TEST PASSED");
    else $display("TEST FAILED %0d error(s)", errors);

    $finish;
end

endmodule
