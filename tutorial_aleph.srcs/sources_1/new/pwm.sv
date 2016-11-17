`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
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
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module pwm(
    input [29:0] limit,
    input [29:0] count,
    input rst,
    input clk,
    output sclk,
    output endPeriod,
    output [3:0] motors
    );
    
    logic [29:0] clk_cnt;
    logic s_endPeriod, s_clk;
    logic [3:0] s_pwmclock;   // Keeps track of the pwm clock
    
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
    
    // PWM
    assign motors = s_pwmclock;
    always @(posedge clk) begin
        if (clk_cnt < limit)
            s_pwmclock = 'hf;
        else
            s_pwmclock = 'h0;
    end
        
    // Period Counter
    assign endPeriod = s_endPeriod;
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
