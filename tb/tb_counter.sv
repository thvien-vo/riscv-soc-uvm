// tb 4 bit counter
module tb_counter;
  logic       clk = 0;
  logic       rst_n = 0;
  logic [3:0] count;

  counter dut (.clk(clk), .rst_n(rst_n), .count(count));

  always #5 clk = ~clk;            // period 10 unit of time

  initial begin
    $dumpfile("dump.vcd");         
    $dumpvars(0, tb_counter);      
    #12 rst_n = 1;                 
    #200;
    $display("Done. count = %0d", count);
    $finish;                       
  end
endmodule

