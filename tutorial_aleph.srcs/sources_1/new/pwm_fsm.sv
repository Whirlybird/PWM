`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: WhirlyBird RTOS Group
// Engineer: Spencer Chang
// 
// Create Date: 10/20/2016 08:23:06 AM
// Design Name: 
// Module Name: pwm_fsm
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: This module controls all the hardware when given IMU (Euler angle)
//                comparator results. It outputs separate PWM values depending on
//                the given results.
// 
// Plan: Do operation on Euler angles. Then, add to PWM.
//
// Revision:
// Revision 0.01 - File Created
// Revision 0.10 - Basic start-up sequence for ESC motors
// Revision 0.20 - Scrap Start-Up and allow for multiple PWM controls
// Revision 1.00 - Made simple FSM for quadcopter that has an INIT, CLR, and FLY
//                 state. The states send a select signal (FullFlight) to a MUX
//                 that selects what PWM the motors will get.
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module pwm_fsm(
    input GO,
    input CLK,
    input RESET,
    output RST,
    output FullFlight,
    output [29:0] Period
    );
    
    // -------- CONSTANTS ---------
    logic [29:0] COUNT = 'd250_000;
    logic INIT = 'd0;
    logic CLR  = 'd1;
    logic FLY = 'd2;
    // ----------------------------
    logic [29:0] clk_cnt;
    logic [1:0] PS, NS = 2'b00, state;           // Store our states
    logic [2:0] s_led;
    logic s_newCLK, s_flight, s_rst;
    logic newCLK;
    
    assign Period = COUNT;
    
    // Clock Divider and Period Counter
    assign newCLK = s_newCLK;
    always @(posedge CLK) begin
        // Initialize the counts.
        if (RESET) begin
            clk_cnt = 'd0;
        end
            
        // Reset the count if it exceeds period count
        if ( clk_cnt > COUNT ) begin
            clk_cnt = 'd0;
            s_newCLK = ~s_newCLK;
        end
        else
            clk_cnt = clk_cnt + 1;
    end
    
    // State Generator
    always @(posedge newCLK) begin
        if (RESET) begin
            PS <= 2'b00;
        end
        else
            PS <= NS;
    end
    
    // STATE CHANGER
    always_comb begin
        case (PS)
            2'b00: state = INIT;
            2'b01: state = CLR;
            2'b10: state = FLY;
            default: state = INIT;
        endcase
    end
    
    // Finite State Machine
    assign FullFlight = s_flight;
    assign RST = s_rst;
    always_comb begin
        // FSM State Logic
        NS <= PS;
        if (state == INIT) begin  // Program the ESCs
            s_flight = 'b0;
            s_rst = 'b0;
            if (GO == 'b1)  // This may be a problem statement
                NS <= CLR;
        end
        else if (state == CLR) begin  // Clear the motor_ctl Blks
            s_flight = 'b0;
            s_rst = 'b1;
            NS <= FLY;
        end
        else if (state == FLY) begin  // Fly forever until turned off
            s_rst = 'b0;
            s_flight = 'b1;
            NS <= FLY;
        end
        else begin
            s_flight = 'b0;
            s_rst = 'b0;
            NS <= INIT; 
        end
    end
endmodule
