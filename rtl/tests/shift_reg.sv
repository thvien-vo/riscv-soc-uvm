// shift_reg: WIDTH-bit, DEPTH-stage shift register built from reg_n
// Author: Vo Nguyen Thanh Vien
module shift_reg #(
    parameter int WIDTH = 8,
    parameter int DEPTH = 3
) (
    input logic clk,
    input logic rst_n,
    input logic en,
    input logic [WIDTH-1:0] d,
    output logic [WIDTH-1:0] q
);

logic [WIDTH-1:0] s [0:DEPTH];

assign s[0] = d;

for (genvar i = 0; i < DEPTH; ++i) begin: g_stage
    reg_n #(.WIDTH(WIDTH)) u_reg (
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .d(s[i]),
        .q(s[i+1])
    );
end

assign q = s[DEPTH];

endmodule
