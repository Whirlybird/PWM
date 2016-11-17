`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/27/2016 10:34:34 AM
// Design Name: 
// Module Name: fsm_sim
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


module fsm_sim(

    );


    logic button, clock, reset, led, initFin;
    logic [3:0] pwmclk;

    pwm_fsm uut(.button(button), .clock(clock), .reset(reset), .led(led), .initFin(initFin), .pwmclk(pwmclk));

always begin
    clock = 'b0;
    #10;
    clock = 'b1;
    #10;
end

initial begin
    reset = 'b1;
    #50;
    reset = 'b0;
    #100;
    button = 'b1;
    #20;
    button = 'b0;
    while(1) begin
       #500;
    end
    $finish;
end

endmodule