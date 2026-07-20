module traffic_light_controller (
    input wire clk,
    input wire reset,
    input wire emergency_ns,
    input wire emergency_ew,
    input wire ped_req_ns,
    input wire ped_req_ew,
    output reg [2:0] light_ns,
    output reg [2:0] light_ew,
    output reg ped_walk_ns,
    output reg ped_walk_ew
);

    parameter S_NS_GREEN  = 3'b000,
              S_NS_YELLOW = 3'b001,
              S_CLEAR_1   = 3'b010,
              S_EW_GREEN  = 3'b011,
              S_EW_YELLOW = 3'b100,
              S_CLEAR_2   = 3'b101;

    reg [2:0] current_state, next_state;
    reg [5:0] timer;
    reg ped_latched_ns, ped_latched_ew;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ped_latched_ns <= 1'b0;
            ped_latched_ew <= 1'b0;
        end else begin
            if (ped_req_ns) 
                ped_latched_ns <= 1'b1;
            else if (current_state == S_NS_YELLOW) 
                ped_latched_ns <= 1'b0;

            if (ped_req_ew) 
                ped_latched_ew <= 1'b1;
            else if (current_state == S_EW_YELLOW) 
                ped_latched_ew <= 1'b0;
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= S_CLEAR_1;
            timer         <= 6'd0;
        end else begin
            if (current_state != next_state) begin
                current_state <= next_state;
                timer         <= 6'd0;
            end else begin
                timer <= timer + 1'b1;
            end
        end
    end

    always @(*) begin
        next_state = current_state;

        if (emergency_ns && !emergency_ew) begin
            if (current_state != S_NS_GREEN)
                next_state = (current_state == S_EW_GREEN) ? S_EW_YELLOW : S_NS_GREEN;
        end 
        else if (emergency_ew && !emergency_ns) begin
            if (current_state != S_EW_GREEN)
                next_state = (current_state == S_NS_GREEN) ? S_NS_YELLOW : S_EW_GREEN;
        end 
        else begin
            case (current_state)
                S_NS_GREEN: begin
                    if ((timer >= 6'd20 && !ped_latched_ns) || (timer >= 6'd30))
                        next_state = S_NS_YELLOW;
                end

                S_NS_YELLOW: begin
                    if (timer >= 6'd4)
                        next_state = S_CLEAR_1;
                end

                S_CLEAR_1: begin
                    if (timer >= 6'd2)
                        next_state = S_EW_GREEN;
                end

                S_EW_GREEN: begin
                    if ((timer >= 6'd20 && !ped_latched_ew) || (timer >= 6'd30))
                        next_state = S_EW_YELLOW;
                end

                S_EW_YELLOW: begin
                    if (timer >= 6'd4)
                        next_state = S_CLEAR_2;
                end

                S_CLEAR_2: begin
                    if (timer >= 6'd2)
                        next_state = S_NS_GREEN;
                end

                default: next_state = S_CLEAR_1;
            endcase
        end
    end

    always @(*) begin
        light_ns    = 3'b100;
        light_ew    = 3'b100;
        ped_walk_ns = 1'b0;
        ped_walk_ew = 1'b0;

        case (current_state)
            S_NS_GREEN: begin
                light_ns    = 3'b001;
                light_ew    = 3'b100;
                ped_walk_ns = ped_latched_ns;
            end

            S_NS_YELLOW: begin
                light_ns = 3'b010;
                light_ew = 3'b100;
            end

            S_CLEAR_1, S_CLEAR_2: begin
                light_ns = 3'b100;
                light_ew = 3'b100;
            end

            S_EW_GREEN: begin
                light_ns    = 3'b100;
                light_ew    = 3'b001;
                ped_walk_ew = ped_latched_ew;
            end

            S_EW_YELLOW: begin
                light_ns = 3'b100;
                light_ew = 3'b010;
            end
        endcase
    end

endmodule