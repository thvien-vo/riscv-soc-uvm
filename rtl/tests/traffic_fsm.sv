module traffic_fsm(
    input logic clk,
    input logic rst_n,
    input logic time_doner,
    output logic red,
    output logic yellow,
    output logic green
);

typedef enum logic [1:0] {
    RED = 2'b00,
    YELLOW = 2'b01,
    GREEN = 2'b10,
    ALL_RED = 2'b11
} light_state_t;

light_state_t next_state, state;

always_ff @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        state <= RED;
    end
    else begin
        state <= next_state;
    end
end

always_comb begin
    next_state = state;
    case (state)
        RED: if (time_doner) next_state = GREEN;
        GREEN: if (time_doner) next_state = YELLOW;
        YELLOW: if (time_doner) next_state = ALL_RED;
        ALL_RED: if (time_doner) next_state = RED;
        default: next_state = RED;
    endcase
end

always_comb begin
    case (state)
        RED: begin 
            red = 1; 
            green = 0; 
            yellow = 0;
        end
        GREEN: begin 
            red = 0; green = 1; yellow = 0;
        end
        YELLOW: begin 
            red = 0; green = 0; yellow = 1;
        end
        ALL_RED: begin 
            red = 1; green = 0; yellow = 0;
        end
        default: begin 
            red = 1; green = 0; yellow = 0;
        end
    endcase
end

endmodule
