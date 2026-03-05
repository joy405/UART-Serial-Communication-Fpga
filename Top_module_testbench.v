`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.03.2026 01:15:42
// Design Name: 
// Module Name: Top_module_testbench
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

`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Testbench for UART TOP_MODULE
// This testbench sends multiple data packets by simulating a button press
// long enough to pass through the debounce module.
//////////////////////////////////////////////////////////////////////////////////

module TOP_MODULE_tb;

// Inputs
reg clk;
reg btn;
reg reset;
reg [7:0] data;

// Outputs
wire TxD;
wire TxD_Debug;
wire transmit_debug;
wire btn_debug;
wire clk_debug;

// DUT instantiation
TOP_MODULE uut (
.clk(clk),
.btn(btn),
.reset(reset),
.data(data),
.TxD(TxD),
.TxD_Debug(TxD_Debug),
.transmit_debug(transmit_debug),
.btn_debug(btn_debug),
.clk_debug(clk_debug)
);

// Clock generation (100 MHz → 10 ns period)
always #5 clk = ~clk;

// Task to send UART data
task send_byte;
input [7:0] value;
begin
data = value;


#20;
btn = 1;        // press button
#700;           // hold long enough for debounce (≥500 ns)
btn = 0;        // release button

#3000;          // wait for UART frame to finish


end
endtask

// Simulation sequence
initial
begin


clk = 0;
btn = 0;
reset = 1;
data = 8'b00000000;

// release reset
#50;
reset = 0;

// transmit multiple bytes
send_byte(8'b10101010);
send_byte(8'b11001100);
send_byte(8'b11110000);
send_byte(8'b01010101);
send_byte(8'b00111100);

#5000;

$stop;


end

endmodule


