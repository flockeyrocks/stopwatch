`timescale 1ns / 1ps

module timer_parameter
    #(parameter FINAL_VALUE = 255)(
    input clk,
    input reset_n,
    input enable,
    //    output [BITS - 1:0] Q, //Uncomment for output
    output done
    );
    
    //determine number of BITS from FINAL_VALUE count
    localparam BITS = $clog2(FINAL_VALUE);
    
    reg [BITS - 1:0] Q_reg, Q_next;
    
    //next state logic with reset and enable
    always @(posedge clk, negedge reset_n)
    begin
        if (~reset_n)
            Q_reg <= 'b0;
        else if(enable)
            Q_reg <= Q_next;
        else
            Q_reg <= Q_reg;
    end
    
    //when Q_reg reaches the desired count, reset to 0
    assign done = Q_reg == FINAL_VALUE;
    always @(*)
        Q_next = done? 'b0: Q_reg + 1;
    
    //Q = Q_reg //Uncomment for output
    
endmodule