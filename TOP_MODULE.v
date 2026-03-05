`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.03.2026 00:58:36
// Design Name: 
// Module Name: TOP_MODULE
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




module TOP_MODULE(
    input clk,
    input btn,           // transmit button
    input reset,         // reset button
    input [7:0] data,
    output TxD,
    output TxD_Debug,
    output transmit_debug,
    output btn_debug,
    output clk_debug
);

    wire transmit_out; // debounced signal

    // Debounce clock
    Debounce_signal DB (
        .clk(clk),
        .btn(btn),
        .transmit(transmit_out)
    );

    // Transmitter block
    Transmitter T1 (
        .clk(clk),
        .reset(reset),
        .transmit(transmit_out),
        .data(data),
        .TxD(TxD)
    );
    // Debug connections
     assign TxD_Debug = TxD;
     assign transmit_debug = transmit_out;
     assign btn_debug = btn;
     assign clk_debug = clk;
     
     
endmodule

