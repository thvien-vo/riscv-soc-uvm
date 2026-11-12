// regfile_pkg: shared constants and types for the register file
// Author: Vo Nguyen Thanh Vien
package regfile_pkg;

    localparam int DATA_W = 32;
    localparam int ADDR_W = 5;
    localparam int NUM_REGS = 1 << ADDR_W;   // 2^5 = 32 registers

    typedef struct packed {
        logic en;
        logic [ADDR_W-1:0] addr;
        logic [DATA_W-1:0] data;
    } wr_reg_t;

endpackage
