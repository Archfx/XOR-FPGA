`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   18:49:01 10/03/2019
// Design Name:   XOR_NN
// Module Name:   C:/Users/Aruna/Documents/ISE/XOR_NN/XOR_NN_test.v
// Project Name:  XOR_NN
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: XOR_NN
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module XOR_NN_test;

	// Inputs
	reg [1:0] x;
	reg clock;
	reg predict;
	// Outputs
	wire [7:0] a3;

	// Instantiate the Unit Under Test (UUT)
	XOR_NN uut (
		.x(x),
		.predict(predict),
		.clock(clock),
		.a3(a3)
	);

	initial begin
		// Initialize Inputs
		x = 2'b10;
		clock = 0;
		predict = 0;

		// Wait 100 ns for global reset to finish
		#100;
        predict = 0;
        #10
        predict = 1;
        #10
        predict = 0;
		// Add stimulus here

	end
	
	initial begin
	forever begin
	 #5 clock = ~clock;
	end 
	end
      
endmodule

