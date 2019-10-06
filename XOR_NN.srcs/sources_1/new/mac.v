//`timescale 1ns/100ps
//exact

module MAC(
	output [16:0] result,
	input [7:0] multiplicand, multiplier,
	input clock, clear
	);
wire [15:0] product;
wire [16:0] temp;
wire [16:0] sum;
reg [16:0] tempSum=17'b0;
reg [1:0] check=2'b0;
Wallace8x8 uut1 (.product(product),.multiplicand(multiplicand),.multiplier(multiplier),.clock(clock),.clear(clear));
cla_adder #(.WIDTH(17)) uut2(.s(sum), .a({1'b0, product}), .b(temp));

always @ (posedge clock, negedge clear)
begin
	if(!clear) 
		tempSum <= 17'b0;
	else begin
		tempSum <= sum;
	end
end

assign result = tempSum;
assign temp = tempSum;

endmodule 
//****************************************************************************
//******************************************************************************


/////////////////////////////////////////////////////////

module cla_adder
	#(parameter WIDTH = 8)
	(
	input [WIDTH-1:0] a,
	input [WIDTH-1:0] b,
	output [WIDTH-1:0] s
	);
     
wire [WIDTH:0] C;
wire [WIDTH-1:0] G, P, SUM;
 
// Full adders
genvar k;
generate
	for (k=0; k<WIDTH; k=k+1) begin
		FULL_ADDER fa ( 
            .a(a[k]),
            .b(b[k]),
            .cin(C[k]),
            .sum(SUM[k]),
            .carry()
        );
    end
endgenerate

assign C[0] = 1'b0;

// Carry terms:
genvar n;
generate
	for (n=0; n<WIDTH; n=n+1) begin
		assign G[n] = a[n] & b[n];
		assign P[n] = a[n] | b[n];
		assign C[n+1] = G[n] | (P[n] & C[n]);
    end
endgenerate

assign s = SUM;
 
endmodule // carry_lookahead_adder





/////////////////////////////////////////////




















//*****************************************************************************************
//******************************************************************************************

module Wallace8x8	(
			output [15:0] product,
			input [7:0] multiplicand, multiplier,
			input clock, clear
			);
 
integer i, j ; 
wire [63:0] s ,c ;                  //-- the signals which will carry the intermediate values  
reg p [7:0][7:0];                   //-- array which stores the partial products 
 
 
always@(multiplier, multiplicand) 
begin 
 
// creating the partial products. 
 
		for (i = 0; i <= 7; i = i + 1) 
		     for (j = 0; j <= 7; j = j + 1) 
			p[j][i] <= multiplicand[j] & multiplier[i];	 
			 
		 
/* 
		all the partial products have been obtained and stored in a array of 8 X 8 matrix. 
		

		-- 						     a7 a6 a5 a4 a3 a2 a1 a0  
		--					 	     b7 b6 b5 b4 b3 b2 b1 b0 
		--						     ------------------------ 
		--				     a7b0 a6b0 a5b0 a4b0 a3b0 a2b0 a1b0 a0b0     |
		--			        a7b1 a6b1 a5b1 a4b1 a3b1 a2b1 a1b1 a0b1	         | 
		-- 			   a7b2 a6b2 a5b2 a4b2 a3b2 a2b2 a1b2 a0b2		 | 
		-- 		      a7b3 a6b3 a5b3 a4b3 a3b3 a2b3 a1b3 a0b3                    | 
		-- 		 a7b4 a6b4 a5b4 a4b4 a3b4 a2b4 a1b4 a0b4                         |-- Stored in array p 
		--          a7b5 a6b5 a5b5 a4b5 a3b5 a2b5 a1b5 a0b5                              | 
		--     a7b6 a6b6 a5b6 a4b6 a3b6 a2b6 a1b6 a0b6                                   | 
		--a7b7 a6b7 a5b7 a4b7 a3b7 a2b7 a1b7 a0b7                                        | 
		------------------------------------------------------------------------------  
*/ 
end 
 
 
/*-- first stage of wallace tree multiplier, first set of three rows are identified 

--			                            a7b0 a6b0 a5b0 a4b0 a3b0 a2b0 a1b0 a0b0    
--			                       a7b1 a6b1 a5b1 a4b1 a3b1 a2b1 a1b1 a0b1	      
-- 			                  a7b2 a6b2 a5b2 a4b2 a3b2 a2b2 a1b2 a0b2					 
                                          --------------------------------------------------- 
--                                        a7b2 s(7) s(6) s(5) s(4) s(3) s(2) s(1) s(0) a0b0 (which is stored in p(0)(0) 
--                                        c(7) c(6) c(5) c(4) c(3) c(2) c(1) c(0) 
                            
*/ 
 
HALF_ADDER ha_11 ( .sum(s[0]), .carry(c[0]), .a(p[1][0]), .b( p[0][1])                 );  
FULL_ADDER fa_11 ( .sum(s[1]), .carry(c[1]), .a(p[2][0]), .b( p[1][1]), .cin( p[0][2]) ); 
FULL_ADDER fa_12 ( .sum(s[2]), .carry(c[2]), .a(p[3][0]), .b( p[2][1]), .cin( p[1][2]) ); 
FULL_ADDER fa_13 ( .sum(s[3]), .carry(c[3]), .a(p[4][0]), .b( p[3][1]), .cin( p[2][2]) ); 
FULL_ADDER fa_14 ( .sum(s[4]), .carry(c[4]), .a(p[5][0]), .b( p[4][1]), .cin( p[3][2]) ); 
FULL_ADDER fa_15 ( .sum(s[5]), .carry(c[5]), .a(p[6][0]), .b( p[5][1]), .cin( p[4][2]) ); 
FULL_ADDER fa_16 ( .sum(s[6]), .carry(c[6]), .a(p[7][0]), .b( p[6][1]), .cin( p[5][2]) );  
HALF_ADDER ha_12 ( .sum(s[7]), .carry(c[7]),              .a( p[7][1]), .b  ( p[6][2]) ); 
 
/* 
-- first stage of wallace tree multiplier, second set of three rows are added 
-- 		       		         a7b3   a6b3   a5b3   a4b3   a3b3   a2b3   a1b3   a0b3      
-- 		   	          a7b4   a6b4   a5b4   a4b4   a3b4   a2b4   a1b4   a0b4            
--               	   a7b5   a6b5   a5b5   a4b5   a3b5   a2b5   a1b5   a0b5   
--              	   ------------------------------------------------------------------- 
--              	   a7b5   s(15)  s(14)  s(13)  s(12)  s(11)  s(10)  s(9)   s(8)   a0b3 
--               	   c(15)  c(14)  c(13)  c(12)  c(11)  c(10)  c(9)   c(8) 
*/ 
 
HALF_ADDER ha_21 ( .sum( s[8] ), .carry( c[8 ]), .a( p[1][3]), .b( p[0][4])                 );  
FULL_ADDER fa_21 ( .sum( s[9] ), .carry( c[9 ]), .a( p[2][3]), .b( p[1][4]), .cin( p[0][5]) ); 
FULL_ADDER fa_22 ( .sum( s[10]), .carry( c[10]), .a( p[3][3]), .b( p[2][4]), .cin( p[1][5]) ); 
FULL_ADDER fa_23 ( .sum( s[11]), .carry( c[11]), .a( p[4][3]), .b( p[3][4]), .cin( p[2][5]) ); 
FULL_ADDER fa_24 ( .sum( s[12]), .carry( c[12]), .a( p[5][3]), .b( p[4][4]), .cin( p[3][5]) ); 
FULL_ADDER fa_25 ( .sum( s[13]), .carry( c[13]), .a( p[6][3]), .b( p[5][4]), .cin( p[4][5]) ); 
FULL_ADDER fa_26 ( .sum( s[14]), .carry( c[14]), .a( p[7][3]), .b( p[6][4]), .cin( p[5][5]) );  
HALF_ADDER ha_22 ( .sum( s[15]), .carry( c[15]),               .a( p[7][4]), .b  ( p[6][5]) ); 
 
/* 
-- second stage of wallace tree multiplier where results of first stage are added with the  
-- remaining rows from first stage. 
--                              a7b2  s(7)  s(6)  s(5)  s(4) s(3) s(2) s(1) s(0) a0b0 
--                              c(7)  c(6)  c(5)  c(4)  c(3) c(2) c(1) c(0) 
--            a7b5  s(15) s(14) s(13) s(12) s(11) s(10) s(9) s(8) a0b3 
--            c(15) c(14) c(13) c(12) c(11) c(10) c(9)  c(8) 
-- 	a7b6  a6b6  a5b6  a4b6  a3b6  a2b6  a1b6  a0b6                                    
-- a7b7 a6b7  a5b7  a4b7  a3b7  a2b7  a1b7  a0b7                                       
------------------------------------------------------------------------------------------- 
 
-- first set of three rows are added in the second stage 
--                              a7b2  s(7)  s(6)  s(5)  s(4)  s(3)  s(2)  s(1)  s(0)  a0b0 
--                              c(7)  c(6)  c(5)  c(4)  c(3)  c(2)  c(1)  c(0) 
--            a7b5  s(15) s(14) s(13) s(12) s(11) s(10) s(9)  s(8)  a0b3 
------------------------------------------------------------------------------------------- 
--            a7b5  s(15) s(14) s(23) s(22) s(21) s(20) s(19) s(18) s(17) s(16) s(0)  a0b0 
--                        c(23) c(22) c(21) c(20) c(19) c(18) c(17) c(16) 
*/ 
 
HALF_ADDER ha_31 ( .sum( s[16]), .carry( c[16]), .a( c[0])   , .b ( s[1])                     );  
FULL_ADDER fa_31 ( .sum( s[17]), .carry( c[17]), .a( c[1])   , .b ( s[2])   , .cin ( p[0][3]) ); 
FULL_ADDER fa_32 ( .sum( s[18]), .carry( c[18]), .a( c[2])   , .b ( s[3])   , .cin ( s[8] )   ); 
FULL_ADDER fa_33 ( .sum( s[19]), .carry( c[19]), .a( c[3])   , .b ( s[4])   , .cin ( s[9] )   ); 
FULL_ADDER fa_34 ( .sum( s[20]), .carry( c[20]), .a( c[4])   , .b ( s[5])   , .cin ( s[10])   ); 
FULL_ADDER fa_35 ( .sum( s[21]), .carry( c[21]), .a( c[5])   , .b ( s[6])   , .cin ( s[11])   ); 
FULL_ADDER fa_36 ( .sum( s[22]), .carry( c[22]), .a( c[6])   , .b ( s[7])   , .cin ( s[12])   );  
FULL_ADDER fa_37 ( .sum( s[23]), .carry( c[23]), .a( c[7])   , .b ( p[7][2]), .cin ( s[13])   ); 
 
 
/* 
-- second set of three rows are added next 
--    		      c(15) c(14) c(13) c(12) c(11) c(10) c(9)  c(8) 
-- 		a7b6  a6b6  a5b6  a4b6  a3b6  a2b6  a1b6  a0b6                                    
--	  a7b7  a6b7  a5b7  a4b7  a3b7  a2b7  a1b7  a0b7      
---------------------------------------------------------------------																			 
--        a7b7  s(31) s(30) s(29) s(28) s(27) s(26) s(25) s(24) c(8) 
--        c(31) c(30) c(29) c(28) c(27) c(26) c(25) c(24)    
*/ 
 
HALF_ADDER ha_41 ( .sum( s[24]), .carry( c[24]), .a( c[9] )  , .b( p[0][6])                 );  
FULL_ADDER fa_41 ( .sum( s[25]), .carry( c[25]), .a( c[10])  , .b( p[1][6]), .cin( p[0][7]) ); 
FULL_ADDER fa_42 ( .sum( s[26]), .carry( c[26]), .a( c[11])  , .b( p[2][6]), .cin( p[1][7]) ); 
FULL_ADDER fa_43 ( .sum( s[27]), .carry( c[27]), .a( c[12])  , .b( p[3][6]), .cin( p[2][7]) ); 
FULL_ADDER fa_44 ( .sum( s[28]), .carry( c[28]), .a( c[13])  , .b( p[4][6]), .cin( p[3][7]) ); 
FULL_ADDER fa_45 ( .sum( s[29]), .carry( c[29]), .a( c[14])  , .b( p[5][6]), .cin( p[4][7]) ); 
FULL_ADDER fa_46 ( .sum( s[30]), .carry( c[30]), .a( c[15])  , .b( p[6][6]), .cin( p[5][7]) );  
HALF_ADDER fa_47 ( .sum( s[31]), .carry( c[31]),               .a( p[7][6]), .b  ( p[6][7]) ); 
 
/* 
-- All the initial partial products have now been added the intermediate sum and carrys are to be added now 
-- This is the third stage of wallace tree multiplication which consists of 4 rows 
--            			a7b5  s(15) s(14) s(23) s(22) s(21) s(20) s(19) s(18) s(17) s(16) s(0) a0b0 
--                        	            c(23) c(22) c(21) c(20) c(19) c(18) c(17) c(16) 
--    	a7b7  s(31) s(30) s(29) s(28) s(27) s(26) s(25) s(24) c(8) 
--    	c(31) c(30) c(29) c(28) c(27) c(26) c(25) c(24)  
----------------------------------------------------------------------------------------------------------- 
 
-- the first set of rows for addition are identified 
--            			a7b5  s(15) s(14) s(23) s(22) s(21) s(20) s(19) s(18) s(17) s(16) s(0) a0b0 
--                                          c(23) c(22) c(21) c(20) c(19) c(18) c(17) c(16) 
--    	            a7b7  s(31) s(30) s(29) s(28) s(27) s(26) s(25) s(24) c(8) 
----------------------------------------------------------------------------------------------------------- 
--                  a7b7  s(31) s(41) s(40) s(39) s(38) s(37) s(36) s(35) s(34) s(33) s(32) s(16) s(0) a0b0 
--                        c(41) c(40) c(39) c(38) c(37) c(36) c(35) c(34) c(33) c(32) 
*/ 
 
HALF_ADDER ha_51 ( .sum( s[32]), .carry( c[32]), .a( s[17])  , .b( c[16])                   );  
HALF_ADDER fa_51 ( .sum( s[33]), .carry( c[33]), .a( s[18])  , .b( c[17])                   );  
FULL_ADDER fa_52 ( .sum( s[34]), .carry( c[34]), .a( s[19])  , .b( c[18]), .cin( c[8] )     );  
FULL_ADDER fa_53 ( .sum( s[35]), .carry( c[35]), .a( s[20])  , .b( c[19]), .cin( s[24])     );  
FULL_ADDER fa_54 ( .sum( s[36]), .carry( c[36]), .a( s[21])  , .b( c[20]), .cin( s[25])     );  
FULL_ADDER fa_55 ( .sum( s[37]), .carry( c[37]), .a( s[22])  , .b( c[21]), .cin( s[26])     );  
FULL_ADDER fa_56 ( .sum( s[38]), .carry( c[38]), .a( s[23])  , .b( c[22]), .cin( s[27])     );  
FULL_ADDER fa_57 ( .sum( s[39]), .carry( c[39]), .a( s[14])  , .b( c[23]), .cin( s[28])     );  
HALF_ADDER ha_52 ( .sum( s[40]), .carry( c[40]), .a( s[15])  ,             .b  ( s[29])     );  
HALF_ADDER ha_53 ( .sum( s[41]), .carry( c[41]), .a( p[7][5]),             .b  ( s[30])     );  
 
/* 
-- The fourth stage of wallace tree multiplication where the results of fourth stage and remaining rows  
-- of fourth stage are added 
-- 
--       a7b7  s(31) s(41) s(40) s(39) s(38) s(37) s(36) s(35) s(34) s(33) s(32) s(16) s(0) a0b0 
--             c(41) c(40) c(39) c(38) c(37) c(36) c(35) c(34) c(33) c(32) 
--    	c(31) c(30) c(29) c(28) c(27) c(26) c(25) c(24)  
-------------------------------------------------------------------------------------------------------- 
--       s(52) s(51) s(50) s(49) s(48) s(47) s(46) s(45) s(44) s(43) s(42) s(32) s(16) s(0) a0b0 
-- c(52) c(51) c(50) c(49) c(48) c(47) c(46) c(45) c(44) c(43) c(42) 
*/ 
 
 
HALF_ADDER ha_61 ( .sum( s[42]), .carry( c[42]), .a( s[33])  , .b( c[32])                   ); 
HALF_ADDER ha_62 ( .sum( s[43]), .carry( c[43]), .a( s[34])  , .b( c[33])                   ); 
HALF_ADDER ha_63 ( .sum( s[44]), .carry( c[44]), .a( s[35])  , .b( c[34])                   ); 
FULL_ADDER fa_61 ( .sum( s[45]), .carry( c[45]), .a( s[36])  , .b( c[35]), .cin( c[24])     );  
FULL_ADDER fa_62 ( .sum( s[46]), .carry( c[46]), .a( s[37])  , .b( c[36]), .cin( c[25])     );  
FULL_ADDER fa_63 ( .sum( s[47]), .carry( c[47]), .a( s[38])  , .b( c[37]), .cin( c[26])     );  
FULL_ADDER fa_64 ( .sum( s[48]), .carry( c[48]), .a( s[39])  , .b( c[38]), .cin( c[27])     );  
FULL_ADDER fa_65 ( .sum( s[49]), .carry( c[49]), .a( s[40])  , .b( c[39]), .cin( c[28])     );  
FULL_ADDER fa_66 ( .sum( s[50]), .carry( c[50]), .a( s[41])  , .b( c[40]), .cin( c[29])     );  
FULL_ADDER fa_67 ( .sum( s[51]), .carry( c[51]), .a( s[31])  , .b( c[41]), .cin( c[30])     );  
HALF_ADDER ha_64 ( .sum( s[52]), .carry( c[52]), .a( p[7][7]),             .b  ( c[31])     ); 
 
// Final stage of wallace tree multiplication where all the results of fourth stage are added and results obtained 
 
HALF_ADDER ha_71 ( .sum( s[53]), .carry( c[53]), .a( s[43])  , .b( c[42])                  ); 
FULL_ADDER fa_71 ( .sum( s[54]), .carry( c[54]), .a( s[44])  , .b( c[43]), .cin ( c[53])   ); 
FULL_ADDER fa_72 ( .sum( s[55]), .carry( c[55]), .a( s[45])  , .b( c[44]), .cin ( c[54])   ); 
FULL_ADDER fa_73 ( .sum( s[56]), .carry( c[56]), .a( s[46])  , .b( c[45]), .cin ( c[55])   ); 
FULL_ADDER fa_74 ( .sum( s[57]), .carry( c[57]), .a( s[47])  , .b( c[46]), .cin ( c[56])   ); 
FULL_ADDER fa_75 ( .sum( s[58]), .carry( c[58]), .a( s[48])  , .b( c[47]), .cin ( c[57])   ); 
FULL_ADDER fa_76 ( .sum( s[59]), .carry( c[59]), .a( s[49])  , .b( c[48]), .cin ( c[58])   ); 
FULL_ADDER fa_77 ( .sum( s[60]), .carry( c[60]), .a( s[50])  , .b( c[49]), .cin ( c[59])   ); 
FULL_ADDER fa_78 ( .sum( s[61]), .carry( c[61]), .a( s[51])  , .b( c[50]), .cin ( c[60])   ); 
FULL_ADDER fa_79 ( .sum( s[62]), .carry( c[62]), .a( s[52])  , .b( c[51]), .cin ( c[61])   ); 
HALF_ADDER ha_72 ( .sum( s[63]), .carry( c[63]),               .a( c[52]), .b   ( c[62])   ); 
  
// The result of last stage is concatenated with the direct outputs of previous stages and  
// Multiplier product is obtained 
 
//always@(negedge clear,s) 
//if(!clear) product <= 16'b0;
//if(clear == 1'b1) product <= 16'b0;  
//else 
assign product = {s[63 : 53],s[42],s[32],s[16],s[0],p[0][0]}; 
 
endmodule 


 //////////////////////////////////////fa
module FULL_ADDER(output sum, carry, input a, b, cin); 
 
assign   sum = a ^ b ^ cin ; 
assign carry = (a & b) | (b & cin) | (cin & a); 
						 
endmodule

//////////////////////////////////////ha
module HALF_ADDER(output sum, carry, input a, b); 
 
assign   sum = a ^ b  ; 
assign carry = (a & b); 
						 
endmodule
