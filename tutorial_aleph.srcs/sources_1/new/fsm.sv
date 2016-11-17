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
    input [1:0] switches,
    output [29:0] count,
    output [29:0] limit
    );

    logic [29:0] s_limit;

    assign count = 'd249_999;
    assign limit = s_limit;
    always_comb begin
        case (switches)
            'b00 : s_limit = 'd74_999;
            'b01 : s_limit = 'd174_999;
            'b10 : s_limit = 'd124_999;
            'b11 : s_limit = 'd199_999;
            default: s_limit = 'd124_999;
        endcase
    end

endmodule
