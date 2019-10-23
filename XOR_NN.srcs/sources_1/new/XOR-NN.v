`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ArchFX
// Engineer: Aruna Jayasena (aruna.15@cse.mrt.ac.lk)
// 
// Create Date:    01:23:05 10/02/2019 
// Design Name:    XOR-N
// Module Name:    XOR-NN 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module XOR_NN(
	input [1:0] x,
	input predict,
	input clock,
	output reg signed [7:0] a3
	);
	
reg [7:0] X [0:3] [0:1];//  = [[8'd0,8'd1], [8'd1,8'd0], [8'd1,8'd1], [8'd0,8'd0]];
reg   y [0:3];//  = {1, 1, 0, 0};

reg signed [7:0] x_0;
reg signed [7:0] x_1;

// W1, W2, B1 and B2 stores the signed weight and Bias values

reg signed  [7:0] W1 [0:2] [0:1];// ={{8'd47,8'd61},{8'd35,8'd46},{8'd55,8'd37}};
reg signed  [7:0] W2 [0:2];//= {8'd75,8'd44,8'd66};

reg signed  [7:0] B1 [0:2];//= {8'd23,8'd7,8'd13};
reg signed  [7:0] B2;// = 8'd33;


reg signed  [7:0] z2 [0:2];// ={8'd0,8'd0,8'd0};
reg signed  [7:0] z3 = 8'd0;

reg signed [16:0] z3_temp_1;
reg signed [16:0] z3_temp_2;

reg signed  [7:0] a2 [0:2];
//reg [7:0] a3 ;

reg en_Hidden;
reg en_Hidden_sigmoid;
reg en_Output;
reg en_Output_sigmoid;
reg en_Display;

wire [7:0] z2_0;
wire [7:0] z2_1;
wire [7:0] z2_2;


wire [7:0] a2_0;
wire [7:0] a2_1;
wire [7:0] a2_2;

wire [7:0] z3_wire;
wire [7:0] a3_wire;

	sigmoid Hidden_0( //Hidden layer neurone 0 sigmoid function
	.in(z2_0),
	.out(a2_0)
	);
	
	sigmoid Hidden_1( //Hidden layer neurone 1 sigmoid function
	.in(z2_1),
	.out(a2_1)
	);
	
	sigmoid Hidden_2( //Hidden layer neurone 2 sigmoid function
	.in(z2_2),
	.out(a2_2)
	);
	
	sigmoid Output( //output layer neurone  sigmoid function
	.in(z3_wire),
	.out(a3_wire)
	);

assign z2_0 =z2[0];
assign z2_1 =z2[1];
assign z2_2 =z2[2];
    
assign z3_wire = z3;

initial begin
    
    
    x_0=8'd0;
    x_1=8'd0;

    // Initializing data set features X1 and X2
    X[0][0]= 8'sd0;
    X[0][1]= 8'sd1;
    X[1][0]= 8'sd1;
    X[1][1]= 8'sd0;
    X[2][0]= 8'sd0;
    X[2][1]= 8'sd0;
    X[3][0]= 8'sd1;
    X[3][1]= 8'sd1;
    
    // Initializing training outputs
    y[0]=1;
    y[1]=1;
    y[2]=0;
    y[3]=0;
   
   // Infered weights from python prototype 
    W1[0][0]=8'sd47;
    W1[0][1]=-8'sd61;
    W1[1][0]=-8'sd35;
    W1[1][1]=-8'sd46;
    W1[2][0]=8'sd55;
    W1[2][1]=-8'sd37;
    
    W2[0]=8'sd75;
    W2[1]=-8'sd44;
    W2[2]=-8'sd66;
    
    B1[0]=-8'sd23;
    B1[1]=8'sd7;
    B1[2]=8'sd13;
    
    B2=8'sd33;
    
end

always @ * begin
    x_0[0:0]=x[0:0];
    x_1[0:0]=x[1:1];
end

always @ (posedge clock,posedge predict) begin
	// Foward propergation
	if (predict) begin
	   en_Hidden=1;
       en_Output=0;
       en_Hidden_sigmoid=0;
       en_Output_sigmoid=0;
       en_Display=0;
       
    end
	else begin
        if (en_Hidden) begin            
            z2[0]<= (W1[0][0]*x_0)+(W1[0][1]*x_1)+(B1[0]);
            z2[1]<= (W1[1][0]*x_0)+(W1[1][1]*x_1)+(B1[1]);
            z2[2]<= (W1[2][0]*x_0)+(W1[2][1]*x_1)+(B1[2]);
            en_Hidden_sigmoid<=1;
            en_Hidden <= 0;
        end
        
        if (en_Hidden_sigmoid) begin
            a2[0][7:0]<=a2_0;
            a2[1][7:0]<=a2_1;
            a2[2][7:0]<=a2_2;
            en_Output<=1;
            en_Hidden_sigmoid<=0;
            
            $display("z20 %d",z2_0);
            $display("z21 %d",z2_1);
            $display("z22 %d",z2_2);
        end
        
        if (en_Output) begin
            z3 <= (W2[0]*a2[0]/17'sd128)+(W2[1]*a2[1]/17'sd128)+(W2[2]*a2[2]/17'sd128)+B2;
            en_Output<=0;
            en_Output_sigmoid<=1;
            $display("a2_0 %d",a2[0]);
            $display("a2_1 %d",a2[1]);
            $display("a2_2 %d",a2[2]);
        end
        
        if (en_Output_sigmoid) begin
            a3<=a3_wire;
            $display("z3 %d",z3);
            en_Output_sigmoid=0;
            en_Display=1;
        end
        
        if (en_Display) begin
            en_Display=0;
            $display("Final prediction percentage for  1 : %d",a3_wire);
        end    
	end
end
endmodule
