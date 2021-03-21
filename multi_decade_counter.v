`timescale 1ns / 1ps

module multi_decade_counter
    // Determines limit of BCD counters 
    #(parameter N0 = 9, N1 = 9)(
    input clk,
    input reset_n,
    input enable,
    output done, // to cascade it even more
    output [3:0] ones, tens
    );
    
    wire done0, done1;
    wire a0, a1;
    
    //when first counter is done, increment the next counter by one
    BCD_counter_param #(N0) D0(
        .clk(clk),
        .reset_n(reset_n),
        .enable(enable),
        .done(done0),
        .Q(ones)
    );
    assign a0 = enable & done0;
    
    BCD_counter_param #(N1) D1(
        .clk(clk),
        .reset_n(reset_n),
        .enable(a0),
        .done(done1),
        .Q(tens)
    );
    assign a1 = a0 & done1;
    
    assign done = a1;
endmodule