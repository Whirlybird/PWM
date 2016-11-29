`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/11/2016 09:47:31 AM
// Design Name: 
// Module Name: fsm
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module pwm_select(
    input [3:0] setPWM1,
    input [3:0] setPWM2,
    input [3:0] setPWM3,
    input [3:0] setPWM4,
    output [29:0] count,
    output [29:0] motor1,
    output [29:0] motor2,
    output [29:0] motor3,
    output [29:0] motor4
    );
    assign count = 'd249_999;
    
    logic [29:0] s_motor1;
    logic [29:0] s_motor2;
    logic [29:0] s_motor3;
    logic [29:0] s_motor4;
    
    assign motor1 = s_motor1;
    always_comb begin
        case (setPWM1)
            'h0 : s_motor1 = 'd74_999;
            'h1 : s_motor1 = 'd84_999;
            'h2 : s_motor1 = 'd94_999;
            'h3 : s_motor1 = 'd104_999;
            'h4 : s_motor1 = 'd114_999;
            'h5 : s_motor1 = 'd124_999;
            'h6 : s_motor1 = 'd134_999;
            'h7 : s_motor1 = 'd144_999;
            'h8 : s_motor1 = 'd154_999;
            'h9 : s_motor1 = 'd164_999;
           'h10 : s_motor1 = 'd179_999;
            default: s_motor1 = 'd124_999;
        endcase
    end

    assign motor2 = s_motor2;
    always_comb begin
        case (setPWM2)
            'h0 : s_motor2 = 'd74_999;
            'h1 : s_motor2 = 'd84_999;
            'h2 : s_motor2 = 'd94_999;
            'h3 : s_motor2 = 'd104_999;
            'h4 : s_motor2 = 'd114_999;
            'h5 : s_motor2 = 'd124_999;
            'h6 : s_motor2 = 'd134_999;
            'h7 : s_motor2 = 'd144_999;
            'h8 : s_motor2 = 'd154_999;
            'h9 : s_motor2 = 'd164_999;
           'h10 : s_motor2 = 'd179_999;
            default: s_motor2 = 'd124_999;
        endcase
    end
    
    assign motor3 = s_motor3;
    always_comb begin
        case (setPWM3)
            'h0 : s_motor3 = 'd74_999;
            'h1 : s_motor3 = 'd84_999;
            'h2 : s_motor3 = 'd94_999;
            'h3 : s_motor3 = 'd104_999;
            'h4 : s_motor3 = 'd114_999;
            'h5 : s_motor3 = 'd124_999;
            'h6 : s_motor3 = 'd134_999;
            'h7 : s_motor3 = 'd144_999;
            'h8 : s_motor3 = 'd154_999;
            'h9 : s_motor3 = 'd164_999;
           'h10 : s_motor3 = 'd179_999;
            default: s_motor3 = 'd124_999;
        endcase
    end
        
    assign motor4 = s_motor4;
    always_comb begin
        case (setPWM4)
            'h0 : s_motor4 = 'd74_999;
            'h1 : s_motor4 = 'd84_999;
            'h2 : s_motor4 = 'd94_999;
            'h3 : s_motor4 = 'd104_999;
            'h4 : s_motor4 = 'd114_999;
            'h5 : s_motor4 = 'd124_999;
            'h6 : s_motor4 = 'd134_999;
            'h7 : s_motor4 = 'd144_999;
            'h8 : s_motor4 = 'd154_999;
            'h9 : s_motor4 = 'd164_999;
           'h10 : s_motor4 = 'd179_999;
            default: s_motor4 = 'd124_999;
        endcase
    end
endmodule

