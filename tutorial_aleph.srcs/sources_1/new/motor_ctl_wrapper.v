`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: WhirlyBird RTOS Group
// Engineer: Spencer Chang
// 
// Create Date: 12/01/2016 09:28:15 AM
// Design Name: 
// Module Name: motor_ctl_wrapper
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Revision 1.00 - Added IP modules to add, subtract, and multiply Throttle and
//                 Euler X and Y values to output adjusted motor PWMs.
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module motor_ctl_wrapper(
    input [23:0] ctlInput,
    input clk,
    input sclr,
    output [29:0] motor1,
    output [29:0] motor2,
    output [29:0] motor3,
    output [29:0] motor4,
    output [29:0] straitPWM
    );
    
    // Split the AXI bus into 3 different buses
    wire [7:0] eulerX = ctlInput[23:16];
    wire [7:0] eulerY = ctlInput[15:8];
    wire [7:0] throttle = ctlInput[7:0];
    wire [8:0] ZEROES = 9'b0;
    
    wire [7:0] sumXY, diffXY;
    // Coefficient corresponds to motor number
    wire [8:0] throttleSum2, throttleSum3;
    wire [8:0] throttleDiff1, throttleDiff4;
    // Multiplication result to get a good value for PWM
    wire [20:0] multPercent, multRes1, multRes2, multRes3, multRes4;
    wire [20:0] s_straitPWM, s_motor1, s_motor2, s_motor3, s_motor4;
    
// -------------- GLOBAL CONTROLS ------------------
    c_x_add_y c_x_add_y_i
    (.A(eulerX),
     .B(eulerY),
     .CLK(clk),
     .SCLR(sclr),
     .S(sumXY));
     
    c_x_sub_y c_x_sub_y_i
    (.A(eulerX),
     .B(eulerY),
     .CLK(clk),
     .SCLR(sclr),
     .S(diffXY));
// --------------------------------------------------

// --------------- STRAIGHT PWM OUT -----------------
    mult_gen_0 mult_percent
    (.A( { 1'b0, throttle } ),
     .CLK(clk),
     .SCLR(sclr),
     .P(multPercent));
     
    c_add_pwm_offset c_add_percent
    (.A(multPercent),
     .CLK(clk),
     .SCLR(sclr),
     .S(s_straitPWM));
    assign straitPWM = { ZEROES, s_straitPWM };
// --------------------------------------------------

// --------------- MOTOR 1 CONTROL ------------------
// Operations: ( Throttle - ( x + y ) ) * 1050 + 75k
// --------------------------------------------------
    c_throttle_sub c_throttle_sub_1
    (.A(throttle),
     .B(sumXY),
     .CLK(clk),
     .SCLR(sclr),
     .S(throttleDiff1));
     
    mult_gen_0 mult_pwm_offset_1
    (.A(throttleDiff1),
     .CLK(clk),
     .SCLR(sclr),
     .P(multRes1));

    c_add_pwm_offset c_add_pwm_offset_1
    (.A(multRes1),
     .CLK(clk),
     .SCLR(sclr),
     .S(s_motor1));
     assign motor1 = { ZEROES, s_motor1 };
// --------------------------------------------------

// --------------- MOTOR 2 CONTROL ------------------
// Operations: ( Throttle + ( x - y ) ) * 1050 + 75k
// --------------------------------------------------
    c_throttle_add c_throttle_add_2
    (.A(throttle),
     .B(diffXY),
     .CLK(clk),
     .SCLR(sclr),
     .S(throttleSum2));
     
    mult_gen_0 mult_pwm_offset_2
    (.A(throttleSum3),
     .CLK(clk),
     .SCLR(sclr),
     .P(multRes2));

    c_add_pwm_offset c_add_pwm_offset_2
    (.A(multRes2),
     .CLK(clk),
     .SCLR(sclr),
     .S(s_motor2));
     assign motor2 = { ZEROES, s_motor2 };
// --------------------------------------------------

// --------------- MOTOR 3 CONTROL ------------------
// Operations: ( Throttle + ( x + y ) ) * 1050 + 75k
// --------------------------------------------------
    c_throttle_add c_throttle_add_1
    (.A(throttle),
     .B(sumXY),
     .CLK(clk),
     .SCLR(sclr),
     .S(throttleSum3));
     
    mult_gen_0 mult_pwm_offset_3
    (.A(throttleSum3),
     .CLK(clk),
     .SCLR(sclr),
     .P(multRes3));

    c_add_pwm_offset c_add_pwm_offset_3
    (.A(multRes3),
     .CLK(clk),
     .SCLR(sclr),
     .S(s_motor3));
     assign motor3 = { ZEROES, s_motor3 };
// --------------------------------------------------

// --------------- MOTOR 4 CONTROL ------------------
// Operations: ( Throttle - ( x - y ) ) * 1050 + 75k
// --------------------------------------------------
    c_throttle_sub c_throttle_sub_4
    (.A(throttle),
     .B(diffXY),
     .CLK(clk),
     .SCLR(sclr),
     .S(throttleDiff4));
     
    mult_gen_0 mult_pwm_offset_4
    (.A(throttleDiff4),
     .CLK(clk),
     .SCLR(sclr),
     .P(multRes4));

    c_add_pwm_offset c_add_pwm_offset_4
    (.A(multRes4),
     .CLK(clk),
     .SCLR(sclr),
     .S(s_motor4));
     assign motor4 = { ZEROES, s_motor4 };
// --------------------------------------------------
     
endmodule
