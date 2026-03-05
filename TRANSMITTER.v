`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.03.2026 12:12:00
// Design Name: 
// Module Name: TRANSMITTER
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


module Transmitter(
    input clk,            // UART input clock
    input reset,          // reset signal
    input transmit,       // btn signal to trigger the UART communication
    input [7:0] data,     // 8-bit parallel data to transmit
    output TxD            // Transmitter serial output.TxD will be held high during reset, or when no transmissions aretaking place
);

// internal variables
reg [3:0] bit_counter;        // counter to count the 10 bits
reg [13:0] baudrate_counter;  // Baud rate divider (reduced from 10415 to ~50 for faster UART simulation in Vivado)
reg [9:0] shift_register;     //10 bits that will serially transmittd throungh UART to the BASYS 3 BOARD
reg state, next_state;        // idle mode and transmitting mode
reg shift;                    //shift signal to start shifting to the UART
reg load;                     //load signal to start loading into the shift right register and also add start and stops it
reg clear;                    // reset the bit counter for UART transmission
reg TxD;

//  UART transmission 
always @(posedge clk)
begin 
    if(reset)
    begin
        state <= 0; //state is idle
        bit_counter <= 0; //counter for bit transmission is reset to 0
        baudrate_counter <= 0;
        TxD <= 1;
    end
    else 
    begin
        baudrate_counter <= baudrate_counter + 1;

        if(baudrate_counter == 50)
        begin
            state <= next_state;//state changes from idle to transmitting
            baudrate_counter <= 0;//resetting the counter

            if(load)//if load is asserted
                shift_register <= {1'b1, data, 1'b0};//data is loaded into the register

            if(clear)// if clear is asserted
                bit_counter <= 0;

            else if(shift)//if shift is asserted
                shift_register <= shift_register >> 1;//start shifting the data and transmitting bit by bit

            bit_counter <= bit_counter + 1;
        end
    end
end


 //mealy machine ,state machine
always @(posedge clk)
begin
    load  <= 0;// setting load equal to 0;
    shift <= 0;//shifting 0 initially
    clear <= 0;
    TxD   <= 1;//when set to 1 there is no tranmission progress

    case(state)

        // Idle State 
        0: begin
            if(transmit)//if transmit button is pressed
            begin
                next_state <= 1;//moves or switeches to tranmission state
                load  <= 1;//start loading the bits
                shift <= 0;//no sift at this point
                clear <= 0;//to avoide any clearing of any counter
            end
            else
            begin//is treansmit button is not pressed'
                next_state <= 0;//stays at the idle mode
                TxD <= 1;//no transmission
            end
        end

        //  Transmitting State 
        1: begin
            if(bit_counter == 10)
            begin
                next_state <= 0;//it should switch from transmission mode to idle mode
                clear <= 0;//clear all the counter
            end
            else
            begin
                next_state <= 1;//stay in the transmitting state
                TxD <= shift_register[0];
                shift <= 1;///continuing shifting the data,and new bit arrives at the RMB;
            end
        end

        default: next_state <= 0;

    endcase
end

endmodule
