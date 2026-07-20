`timescale 1ns / 1ps

module tb;

    reg clk;
    reg reset;
    reg emergency_ns;
    reg emergency_ew;
    reg ped_req_ns;
    reg ped_req_ew;

    wire [2:0] light_ns;
    wire [2:0] light_ew;
    wire ped_walk_ns;
    wire ped_walk_ew;

    traffic_light_controller uut (
        .clk(clk),
        .reset(reset),
        .emergency_ns(emergency_ns),
        .emergency_ew(emergency_ew),
        .ped_req_ns(ped_req_ns),
        .ped_req_ew(ped_req_ew),
        .light_ns(light_ns),
        .light_ew(light_ew),
        .ped_walk_ns(ped_walk_ns),
        .ped_walk_ew(ped_walk_ew)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
        emergency_ns = 0;
        emergency_ew = 0;
        ped_req_ns = 0;
        ped_req_ew = 0;

        $monitor("Time=%0t | RST=%b | EMG_NS=%b EMG_EW=%b | PED_NS=%b PED_EW=%b | L_NS=%b L_EW=%b | WALK_NS=%b WALK_EW=%b", 
                 $time, reset, emergency_ns, emergency_ew, ped_req_ns, ped_req_ew, light_ns, light_ew, ped_walk_ns, ped_walk_ew);

        #15;
        reset = 0;

        #200;

        ped_req_ns = 1;
        #10;
        ped_req_ns = 0;

        #300;

        emergency_ew = 1;
        #80;
        emergency_ew = 0;

        #200;
        $finish;
    end

    initial begin
        $dumpfile("traffic_light_tb.vcd");
        $dumpvars(0, tb);
    end

endmodule