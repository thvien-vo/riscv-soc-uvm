`timescale 1ps/1ps

module tb_traffic_fsm;
logic clk;
logic rst_n;
logic time_doner;
logic red;
logic yellow;
logic green;
int errors = 0;

traffic_fsm dut(
    .clk(clk),
    .rst_n(rst_n),
    .time_doner(time_doner),
    .red(red),
    .yellow(yellow),
    .green(green)    
);

task automatic check_lights(
    input logic exp_r, exp_y, exp_g, input string name
);
    if (red !== exp_r || yellow !== exp_y || green !== exp_g) begin
        $display("ERROR at %0t: expected %s (r=%b y=%b g=%b), got r=%b y=%b g=%b", 
            $time, name, exp_r, exp_y, exp_g, red, yellow, green);
        errors++;
    end
endtask

initial clk = 1'b0;
always #5 clk = ~clk;

initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, tb_traffic_fsm);

    rst_n = 1'b0;
    time_doner = 1'b0;
    repeat (2) @(posedge clk);
    rst_n = 1'b1;
    @(negedge clk);
    check_lights(1'b1, 1'b0, 1'b0, "RED");

    @(negedge clk) time_doner = 1'b1;   
    @(negedge clk) time_doner = 1'b0;
    check_lights(1'b0, 1'b0, 1'b1, "GREEN");    
    repeat (2) @(posedge clk);          
    @(negedge clk) time_doner = 1'b1;    
    @(negedge clk) time_doner = 1'b0; 
    check_lights(1'b0, 1'b1, 1'b0, "YELLOW");   
    repeat (2) @(posedge clk);           
    @(negedge clk) time_doner = 1'b1;   
    @(negedge clk) time_doner = 1'b0;   
    check_lights(1'b1, 1'b0, 1'b0, "ALL_RED");
    repeat (2) @(posedge clk);           
    @(negedge clk) time_doner = 1'b1;   
    @(negedge clk) time_doner = 1'b0;    
    check_lights(1'b1, 1'b0, 1'b0, "RED");
    repeat (2) @(posedge clk);           

    if (errors == 0) $display("TEST PASSED");
    else $display("TEST FAILED: %0d error(s)", errors);           

    $finish;
end

endmodule
