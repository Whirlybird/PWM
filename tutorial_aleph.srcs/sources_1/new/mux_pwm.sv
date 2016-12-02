`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: WhirlyBird RTOS Group
// Engineer: Spencer Chang
// 
// Create Date: 12/01/2016 09:49:10 PM
// Design Name: 
// Module Name: mux_pwm
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Revision 1.00 - Simple MUX created to choose what PWM the motors will get.
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module mux_pwm(
    input Sel,
    input [29:0] In1,
    input [29:0] In2,
    input [29:0] In3,
    input [29:0] In4,
    input [29:0] Percent,
    output [29:0] Pwm1,
    output [29:0] Pwm2,
    output [29:0] Pwm3,
    output [29:0] Pwm4
    );
    
    logic [29:0] s_Pwm1, s_Pwm2, s_Pwm3, s_Pwm4;
    
    assign Pwm1 = s_Pwm1;
    assign Pwm2 = s_Pwm2;
    assign Pwm3 = s_Pwm3;
    assign Pwm4 = s_Pwm4;
    always_comb begin
        if ( Sel == 'b0 ) begin
            s_Pwm1 = Percent;
            s_Pwm2 = Percent;
            s_Pwm3 = Percent;
            s_Pwm4 = Percent;
        end
        else begin
            s_Pwm1 = In1;
            s_Pwm2 = In2;
            s_Pwm3 = In3;
            s_Pwm4 = In4;
        end
    end
    
endmodule
