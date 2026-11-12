// hs_pass: pass-through between two hs_if bundles (receiver side -> sender side)
// Author: Vo Nguyen Thanh Vien
module hs_pass(
    hs_if.sender tx,
    hs_if.receiver rx
);

assign tx.valid = rx.valid;
assign tx.data = rx.data;
assign rx.ready = tx.ready;

endmodule
