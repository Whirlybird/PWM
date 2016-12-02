`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: WhirlyBird RTOS Group
// Engineer: Spencer Chang
// 
// Create Date: 11/10/2016 08:18:46 AM
// Design Name: 
// Module Name: pwm
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: The module outputs the actual PWM using a clock from an outside
//              clock_div module.
//              *** This can be modified later to have specific PWM for 4 motors.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Revision 0.1  - Create Sequential, Clk-triggered PWM with 400 Hz Frequency.
// Revision 0.11 - Split PWM into separate motors.
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module pwm(
    input [29:0] pwm1,
    input [29:0] pwm2,
    input [29:0] pwm3,
    input [29:0] pwm4,
    input [29:0] count,
    input rst,
    input clk,
//    output sclk,
//    output endPeriod,
    output [3:0] motors
    );
    
    logic [29:0] clk_cnt;
    logic s_endPeriod, s_clk;
    logic [3:0] s_pwmclock;   // Keeps track of the pwm clock
    logic s_motor1, s_motor2, s_motor3, s_motor4;
    
    // Concatenate into bus
    assign motors = {s_motor4, s_motor3, s_motor2, s_motor1};
    
    // SCLK
    assign SCLK = s_clk;
    always @(posedge clk) begin
        // Reset
        if (rst) begin
            clk_cnt = 'd0;
            s_clk = 'b0;
        end
        
        // Slow the clock
        if ( clk_cnt > count ) begin
            clk_cnt = 'd0;
            s_clk = ~s_clk;
        end
        else
            clk_cnt = clk_cnt + 1;
    end
    
    // PWM - Motor 1
    always @(posedge clk) begin
        if (clk_cnt < pwm1)
            s_motor1 = 'b1;
        else
            s_motor1 = 'b0;
    end
    
    // PWM - Motor 2
    always @(posedge clk) begin
        if (clk_cnt < pwm2)
            s_motor2 = 'b1;
        else
            s_motor2 = 'b0;
    end
    
    // PWM - Motor 3
    always @(posedge clk) begin
        if (clk_cnt < pwm3)
            s_motor3 = 'b1;
        else
            s_motor3 = 'b0;
    end 
    
    // PWM - Motor 4
    always @(posedge clk) begin
        if (clk_cnt < pwm4)
            s_motor4 = 'b1;
        else
            s_motor4 = 'b0;
    end
        
    // Period Counter - May not still be needed...
    //assign endPeriod = s_endPeriod;
    always @(posedge clk) begin
        // Initialize the counts.
        if (rst) begin
            s_endPeriod = 'd0;
        end
            
        // Reset the count if it exceeds period count
        if ( clk_cnt > count )
            s_endPeriod = 'd1;
        else
            s_endPeriod = 'd0;
    end
endmodule
