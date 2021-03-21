`timescale 1ns / 1ps

//used decade bcd counter cascade for implmentation

module stopwatch
    //count for 10ms count
    #(parameter CLOCK_COUNT = 999999)(
    input clk, up, down, load, reset_n,
    output [7:0] AN,
    output [6:0] sseg,
    output DP
    );
    
    wire [3:0] ones_ms, tens_ms, ones_sec, tens_sec, ones_min, tens_min;
    wire [5:0] I0, I1, I2, I3, I4, I5;
    wire load_debounce;
    wire enable;
    wire done0, done1;
    wire slow_clk;
    wire DP_ctrl_on, DP_ctrl_off;
    reg en_count;
    
    //always enable
    assign enable = 1;
    
    //DP_ctrl used late in concatenation
    assign DP_ctrl_on = 0;
    assign DP_ctrl_off = 1;
    
    
    button load_button(
        .clk(clk),
        .in(load),
        .out(load_debounce)
    );
    
    //previous load_debounce used for start/stop
    always @(load_debounce)
    begin
        if(load_debounce)
            en_count = !en_count;
        else
            en_count = en_count;
    end
    
    //slow down clock to 10ms for stopwatch
    timer_parameter #(CLOCK_COUNT) clk_div (
        .clk(clk),
        .reset_n(1),
        .enable(en_count),
        .done(slow_clk)
    );
    
    //lower 2 bits (ms) limits set to 9 for both digits
    multi_decade_counter #(9, 9) first_2_bits(
        .clk(clk),
        .reset_n(reset_n),
        .enable(slow_clk),
        .done(done0),
        .ones(ones_ms),
        .tens(tens_ms)
    );
    
    //middle 2 bits (sec) limits set to 5 and 9 for 59 seconds
    multi_decade_counter #(9, 5) second_2_bits(
        .clk(clk),
        .reset_n(reset_n),
        .enable(done0),
        .done(done1),
        .ones(ones_sec),
        .tens(tens_sec)
    );
    
    //middle 2 bits (min) limits set to 5 and 9 for 59 minutes
    multi_decade_counter #(9, 5) third_2_bits(
        .clk(clk),
        .reset_n(reset_n),
        .enable(done1),
        .done(done2),
        .ones(ones_min),
        .tens(tens_min)
    );
    
    //always enable, enter hex values, DP on to separate timer
    assign I5={enable,tens_min,DP_ctrl_off};
    assign I4={enable,ones_min,DP_ctrl_on}; 
    assign I3={enable,tens_sec,DP_ctrl_off}; 
    assign I2={enable,ones_sec,DP_ctrl_on};
    assign I1={enable,tens_ms,DP_ctrl_off}; 
    assign I0={enable,ones_ms,DP_ctrl_off}; 
    
    sseg_driver output_driver(
        .I0(I0),
        .I1(I1),
        .I2(I2),
        .I3(I3),
        .I4(I4),
        .I5(I5),
        .clk(clk),
        .AN(AN),
        .bcd(sseg),
        .DP(DP)
    );
    
endmodule
