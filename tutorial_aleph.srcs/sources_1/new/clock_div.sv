`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/20/2016 08:23:06 AM
// Design Name: 
// Module Name: clock_div
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: This module will generate PWM signals based on an upper limit.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module pwm_fsm(
    input button,
    input clock,
    input reset,
    output [1:0] led,
    output initFin,
    output [3:0] pwmclk
    );
    
    logic [29:0] END_PERIOD_CNT = 'd3000;  // Constant period count
    logic [29:0] COUNT = 'd199_999;      // Constant 500 Hz count for PWM
    
    logic [1:0] PS, NS = 2'b00, state;           // Store our states
    logic newState, unlock;              // State changing 'signals'
    logic [29:0] clk_cnt;                // Initialize
    logic [29:0] period_cnt;
    logic [29:0] limit;
    logic [3:0] newclock, s_newclock;
    logic [1:0] s_led;
    logic s_initFin;
    
    assign pwmclk = newclock;     // Output the new PWM clock
    assign led = s_led;           // Mimic the switch input with the LEDs
    assign initFin = s_initFin;   // Display that the initialization has finished
    
    // State Generator
    always @(posedge clock) begin
        if (reset) begin
            PS <= 2'b00;
        end
        else
            PS <= NS;
    end
    
    // Clock Divider and Period Counter
    always @(posedge clock) begin
        newclock = s_newclock;
        // Initialize the counts.
        if (reset || button) begin
            clk_cnt = 'd0;
            period_cnt = 'd0;
        end
        
        // Control state signal
        if (unlock && (period_cnt == END_PERIOD_CNT - 'd1)) 
            unlock = 'b0;
        else if (period_cnt == 'd0)
            unlock = 'b1; 
            
        // Reset the count if it exceeds period count
        if ( clk_cnt > COUNT ) begin
            clk_cnt = 'd0;
            period_cnt = period_cnt + 1;
        end
        else
            clk_cnt = clk_cnt + 1;
            
        // Count the periods
        if (period_cnt == END_PERIOD_CNT) begin
            period_cnt = 0;
        end
    end
    
// ---------------------- COMBINATORIAL BELOW --------------------------
    // STATE CHANGER
    always_comb begin
        case (PS)
            2'b00: state = 'd0;
            2'b01: state = 'd1;
            2'b10: state = 'd2;
            2'b11: state = 'd3;
            default: state = 'd0;
        endcase
    end

    // Finite State Machine
    always_comb begin
        // PWM 'Maker'
        if ( clk_cnt > limit )
            s_newclock = 4'h0;
        else
            s_newclock = 4'hF;
            
        // Set default for limit, leds
        limit = 'd99_999;
        s_led = 'b0;
        // Allow a newState to occur.
        if (unlock && (period_cnt == END_PERIOD_CNT - 'd1) ) begin
            newState = 'b1;
        end
        else
            newState = 'b0;
        
        // FSM State Logic
        NS <= PS;
        if (state == 'd0) begin
            s_led = 2'b00;
            if (button) begin
               s_initFin = 'b0;
               s_led = 'b1;
               newState = 'b0;
               NS <= 2'b01;
            end
        end
        else if (state == 'd1) begin
            s_led = 2'b01;
            s_initFin = 'b0;
            limit = 'd139_999;        // 140 -> 70%
            if (newState == 'b1) begin
               newState = 'b0;
               NS <= 2'b10;
            end
        end
        else if (state == 'd2) begin
            s_led = 2'b10;
            s_initFin = 'b0;
            limit = 'd59_999;         // 60 -> 30%
            if (newState == 'b1) begin
               newState = 'b0;
               NS <= 2'b11;
            end
        end
        else if (state == 'd3) begin
            s_led = 2'b11;
            limit = 'd99_999;        // 100 -> 50%
            s_initFin = 'b0;
            if (newState == 'b1) begin
               newState = 'b0;
               s_initFin = 'b1;         // Finished the PWM initialization
               NS <= 2'b00;
            end
        end
        else begin
            limit = 'd99_999;        // 50%
            s_initFin = 'b0;
            s_led = 'b0;
            newState = 'b0;
            NS <= 2'b00;
        end
    end
//------------- DUTY CYCLES ------------
//- COUNT = 'd199_999;   // 500Hz      -
//- limit = 'd59_999;    // 60 ->  30% -
//- limit = 'd79_999;    // 80 ->  40% -
//- limit = 'd99_999;    // 100 -> 50% -
//- limit = 'd119_999;   // 120 -> 60% -
//- limit = 'd139_999;   // 140 -> 70% -
//--------------------------------------
endmodule
