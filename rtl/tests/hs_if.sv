// hs_if: valid/ready handshake bundle with sender, receiver and monitor modports
// Author: Vo Nguyen Thanh Vien
interface hs_if #(
    parameter WIDTH = 32
);
    logic valid;
    logic [WIDTH-1:0] data;
    logic ready;

    modport sender(output valid, output data, input ready);
    modport receiver(input valid, input data, output ready);
    modport monitor(input valid, input data, input ready);
endinterface 
