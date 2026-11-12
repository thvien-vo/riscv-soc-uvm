// regfile: RV32I register file, 32 x 32-bit, 1 write port, 2 combinational read ports, x0 = 0
// Author: Vo Nguyen Thanh Vien
module regfile 
    import regfile_pkg::*; (
    input logic clk,
    input logic rst_n,
    input wr_reg_t wr_reg,
    input logic [ADDR_W-1:0] rs1_addr,
    input logic [ADDR_W-1:0] rs2_addr,
    output logic [DATA_W-1:0] rs1_data,
    output logic [DATA_W-1:0] rs2_data
);

logic [DATA_W-1:0] regs [NUM_REGS-1:0];

always_ff @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        for(int i = 0; i < NUM_REGS; ++i) begin
            regs[i] <= '0;
        end
    end
    else if (wr_reg.en == 1'b1 && wr_reg.addr != '0) begin
        regs[wr_reg.addr] <= wr_reg.data;
    end
end

assign rs1_data = (rs1_addr != '0) ? regs[rs1_addr] : '0;
assign rs2_data = (rs2_addr != '0) ? regs[rs2_addr] : '0;

endmodule
