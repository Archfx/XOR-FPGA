`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   09:59:51 10/02/2019
// Design Name:   MAC
// Module Name:   C:/Users/Aruna/Documents/ISE/XOR_NN/mac_test.v
// Project Name:  XOR_NN
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: MAC
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module mac_test;

	// Inputs
	reg [7:0] multiplicand;
	reg [7:0] multiplier;
	reg clock;
	reg clear;

	// Outputs
	wire [16:0] result;

	// Instantiate the Unit Under Test (UUT)
	MAC uut (
		.result(result), 
		.multiplicand(multiplicand), 
		.multiplier(multiplier), 
		.clock(clock), 
		.clear(clear)
	);

	initial begin
		// Initialize Inputs
		multiplicand = 0;
		multiplier = 0;
		clock = 0;
		clear = 0;

		// Wait 100 ns for global reset to finish
		#100;
		multiplicand = 8'sd10;
		multiplier = 8'sd10;
      clear=1;
		#10
		clear= 1;
		#10
		multiplicand = 8'sd20;
		multiplier = 8'sd20;
		
		// Add stimulus here

	end
	
		initial begin
	forever begin
	 #5 clock = ~clock;
	end 
	end
      
endmodule

