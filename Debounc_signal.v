`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.03.2026 00:29:27
// Design Name: 
// Module Name: Debounc_signal
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


module Debounce_signal #(parameter thresold =50)
(
    input clk,//input signal
    input btn,//input button for transmit and reset
    output transmit// transmit signal;
    );
    
    reg button_ff1=0;//button  FF for  synchronization initially set to 0
    reg button_ff2=0;//button  FF for  synchronization initially set to 0
    reg [7:0] count=0;//8 bits count for incremnet and decremnet when button is pressed or released.
    reg transmit;
    //first use two FF to synchronize the button signals , "clk" ,clock domain
    
    always @(posedge clk)
    begin
    button_ff1<=btn;
    button_ff2<=button_ff1;
    end
    
    //when the push button is pressed or released or increment or decremnet the counter
    
    always @(posedge clk)
    begin
    if(button_ff2)//if button__ff2 is high 
    begin
    if(~&count) //if it isn't at the count limit ,make sure that u won't count up  at the limit.First AND all count and then not the AND
    count<=count+1;//when button is pressed count up
    end
    else
     begin
    if(|count)//if count has atleast 1 in it ,making sure no subtract when count is 0
    count<=count-1;//when button is released count down
    end
    if(count>thresold)//if the count is larger than thresold
    transmit<=1;//debounc the signal is 1
    else
    transmit<=0;// debounced signal is 0;
    end
   
    
    
    
    
    
   
    
    
    
endmodule
