`timescale 1ns / 1ps
module bin2bcd(
    input [7:0] bin,
    output [11:0] bcd
    );
    
    wire [3:0] in_add1, in_add2, in_add3, in_add4, in_add5, in_add6, in_add7, 
               stage1, stage2, stage3, stage4, stage5, stage6, stage7;
    
    //implementation of double-dabble algorithm
    assign in_add1 = {0,bin[7],bin[6],bin[5]};
    add_3 add1 (.A(in_add1), .S(stage1));
    
    assign in_add2 = {stage1[2],stage1[1],stage1[0],bin[4]};
    add_3 add2 (.A(in_add2), .S(stage2));
    
    assign in_add3 = {stage2[2],stage2[1],stage2[0],bin[3]};
    add_3 add3 (.A(in_add3), .S(stage3));
    
    assign in_add4 = {stage3[2],stage3[1],stage3[0],bin[2]};
    add_3 add4 (.A(in_add4), .S(stage4));
    
    assign in_add5 = {stage4[2],stage4[1],stage4[0],bin[1]};
    add_3 add5 (.A(in_add5), .S(stage5));
    
    assign in_add6 = {0,stage1[3],stage2[3],stage3[3]};
    add_3 add6 (.A(in_add6), .S(stage6));
    
    assign in_add7 = {stage6[2],stage6[1],stage6[0],stage4[3]};
    add_3 add7 (.A(in_add7), .S(stage7));
    
    assign bcd[11] = 0;
    assign bcd[10] = 0;
    assign bcd[9] = stage6[3];
    assign bcd[8] = stage7[3];
    assign bcd[7] = stage7[2];
    assign bcd[6] = stage7[1];
    assign bcd[5] = stage7[0];
    assign bcd[4] = stage5[3];
    assign bcd[3] = stage5[2];
    assign bcd[2] = stage5[1];
    assign bcd[1] = stage5[0];
    assign bcd[0] = bin[0];
    
endmodule
