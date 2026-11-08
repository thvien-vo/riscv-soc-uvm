// reg_n: register WIDTH bit, with enable, rst async active-low
// Author: Vo Nguyen Thanh Vien

module reg_n #(parameter int WIDTH = 8) (
    input logic clk,
    input logic rst_n,
    input logic en,
    input logic [WIDTH-1:0] d,
    output logic [WIDTH-1:0] q
);

always_ff @(posedge clk, negedge rst_n) begin
    if (!rst_n) q <= '0;
    else if (en) q <= d;
end

endmodule
