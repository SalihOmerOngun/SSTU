`timescale 1ns / 1ps


//module arithmetic_circuits_tb(); // bence gerek yok
//endmodule // bence gerek yok 


module HA_tb();

	reg X= 1'b0;
	reg Y= 1'b0;
	wire COUT;
	wire SUM;
	
	HA uut
	(
		.x(X),
		.y(Y),
		.cout(COUT),
		.sum(SUM)
	);
	
	initial 
	begin
		X = 0;
		Y = 0;
		#10;

		X = 0;
		Y = 1;
		#10;		

		X = 1;
		Y = 0;
		#10;		
		
		X = 1;
		Y = 1;
		#10;
		$finish;
	end
endmodule	


module FA_tb();

	reg X= 1'b0;
	reg Y= 1'b0;
	reg CIN= 1'b0;
	wire COUT;
	wire SUM;
	
	FA uut
	(
		.x(X),
		.y(Y),
		.cin(CIN),
		.cout(COUT),
		.sum(SUM)
	);
	
	initial 
	begin
		X = 0;
		Y = 0;
		CIN = 0;	
		#10;

		X = 0;
		Y = 0;
		CIN = 1;	
		#10;	

		X = 0;
		Y = 1;
		CIN = 0;	
		#10;	
		
		X = 0;
		Y = 1;
		CIN = 1;	
		#10;
		
		X = 1;
		Y = 0;
		CIN = 0;	
		#10;
		
		X = 1;
		Y = 0;
		CIN = 1;	
		#10;
		
		X = 1;
		Y = 1;
		CIN = 0;	
		#10;
		
		X = 1;
		Y = 1;
		CIN = 1;	
		#10;		
		$finish;
	end
endmodule	


module RCA_tb();

	reg [3:0] X= 4'b0;
	reg [3:0] Y= 4'b0;
	reg CIN= 1'b0;
	wire COUT;
	wire [3:0] SUM;
	
	RCA uut
	(
		.x(X),
		.y(Y),
		.cin(CIN),
		.cout(COUT),
		.sum(SUM)
	);
	
	initial 
	begin
		X = 4'b0000;
		Y = 4'b0000;
		CIN = 0;	
		#10;

		X = 4'b0000;
		Y = 4'b0000;
		CIN = 1;	
		#10;
	

		X = 4'b0001;
		Y = 4'b0010;
		CIN = 0;	
		#10;

		
		X = 4'b0011;
		Y = 4'b0011;
		CIN = 0;	
		#10;

		
		X = 4'b0100;
		Y = 4'b0100;
		CIN = 0;	
		#10;

		
		X = 4'b1000;
		Y = 4'b1000;
		CIN = 0;	
		#10;

		
		X = 4'b1001;
		Y = 4'b1011;
		CIN = 0;	
		#10;

		
		X = 4'b1100;
		Y = 4'b1010;
		CIN = 0;	
		#10;		
		
		X = 4'b1100;
		Y = 4'b1010;
		CIN = 1;	
		#10;
		
		X = 4'b1111;
		Y = 4'b1111;
		CIN = 1;	
		#10;
		
		
		$finish;
	end
endmodule	


module parametric_RCA_tb();

parameter SIZE = 8;

	reg [SIZE-1:0] X;
	reg [SIZE-1:0] Y;
	reg CIN;
	wire COUT;
	wire [SIZE-1:0] SUM;

	parametric_RCA #(.SIZE(SIZE)) uut
	(
		.x(X),
		.y(Y),
		.cin(CIN),
		.cout(COUT),
		.sum(SUM)
	);	
	
	initial 
	begin
		X = 8'b00000000;
		Y = 8'b00000000;
		CIN = 0;	
		#10;

		X = 8'b00000000;
		Y = 8'b00000000;
		CIN = 1;	
		#10;
	

		X = 8'b00000001;
		Y = 8'b00000011;
		CIN = 0;	
		#10;

		
		X = 8'b00001000;
		Y = 8'b00001000;
		CIN = 0;	
		#10;

		
		X = 8'b00001100;
		Y = 8'b00001011;
		CIN = 0;	
		#10;

		
		X = 8'b00010000;
		Y = 8'b00011011;
		CIN = 0;	
		#10;

		
		X = 8'b001001100;
		Y = 8'b01001011;
		CIN = 0;	
		#10;

		
		X = 8'b10000000;
		Y = 8'b10000000;
		CIN = 0;	
		#10;	
		
		X = 8'b01001100;
		Y = 8'b00101011;
		CIN = 0;	
		#10;
		
		X = 8'b11111111;
		Y = 8'b11111111;
		CIN = 0;	
		#10;
		
		X = 8'b11111111;
		Y = 8'b11111111;
		CIN = 1;	
		#10;
		
		$finish;
	end
endmodule	
		
module CLA_tb();

parameter SIZE = 8;

	reg [SIZE-1:0] X;
	reg [SIZE-1:0] Y;
	reg CIN;
	wire COUT;
	wire [SIZE-1:0] S;

	CLA #(.SIZE(SIZE)) uut
	(
		.x(X),
		.y(Y),
		.cin(CIN),
		.cout(COUT),
		.s(S)
	);	
	
	initial 
	begin
		X = 8'b00000000;
		Y = 8'b00000000;
		CIN = 0;	
		#10;

		X = 8'b00000000;
		Y = 8'b00000000;
		CIN = 1;	
		#10;
	

		X = 8'b00000001;
		Y = 8'b00000011;
		CIN = 0;	
		#10;

		
		X = 8'b00001000;
		Y = 8'b00001000;
		CIN = 0;	
		#10;

		
		X = 8'b00001100;
		Y = 8'b00001011;
		CIN = 0;	
		#10;

		
		X = 8'b00010000;
		Y = 8'b00011011;
		CIN = 0;	
		#10;

		
		X = 8'b001001100;
		Y = 8'b01001011;
		CIN = 0;	
		#10;

		
		X = 8'b10000000;
		Y = 8'b10000000;
		CIN = 0;	
		#10;	
		
		X = 8'b01001100;
		Y = 8'b00101011;
		CIN = 0;	
		#10;
		
		X = 8'b11111111;
		Y = 8'b11111111;
		CIN = 0;	
		#10;
		
		X = 8'b11111111;
		Y = 8'b11111111;
		CIN = 1;	
		#10;
		
		$finish;
	end
endmodule			

module Behav_adder_tb();

parameter SIZE = 8;

	reg [SIZE-1:0] X;
	reg [SIZE-1:0] Y;
	wire COUT;
	wire [SIZE-1:0] SUM;

	Behav_adder #(.SIZE(SIZE)) uut
	(
		.x(X),
		.y(Y),
		.cout(COUT),
		.sum(SUM)
	);	
	
	initial 
	begin
		X = 8'b00000000;
		Y = 8'b00000000;
		#10;

		X = 8'b00000000;
		Y = 8'b00000000;
		#10;
	

		X = 8'b00000001;
		Y = 8'b00000011;
		#10;

		
		X = 8'b00001000;
		Y = 8'b00001000;
		#10;

		
		X = 8'b00001100;
		Y = 8'b00001011;
		#10;

		
		X = 8'b00010000;
		Y = 8'b00011011;
		#10;

		
		X = 8'b001001100;
		Y = 8'b01001011;
		#10;

		
		X = 8'b10000000;
		Y = 8'b10000000;	
		#10;	
		
		X = 8'b01001100;
		Y = 8'b00101011;
		#10;
		
		X = 8'b11111111;
		Y = 8'b11111111;
		#10;
		
		X = 8'b11111111;
		Y = 8'b11111111;
		#10;
		
		$finish;
	end
endmodule	


module Add_Sub_tb();

	reg [3:0] A= 4'b0;
	reg [3:0] B= 4'b0;
	reg CIN= 1'b0;
	wire COUT;
	wire [3:0] SUM;
	wire OVERFLOW;
	
	Add_Sub uut
	(
		.A(A),
		.B(B),
		.cin(CIN),
		.cout(COUT),
		.overflow(OVERFLOW),
		.sum(SUM)
	);
	integer i;
	integer k;
	integer j;
	
	initial
	begin
		$display("Time | CIN | A    | B    | SUM  | COUT | OVERFLOW");
		$display("---------------------------------------------------");
		for(k = 0; k<2; k = k+1) begin
		  CIN = k;
			for(i = -8; i<8; i = i+1) begin
			 A = i;
				for(j = -8; j<8; j = j+1) begin
				    B = j;
					#5;
					$display("%4t | %b   | %0d  | %0d  | %0d  | %b    | %b", 
								$time, CIN, $signed(A), $signed(B), $signed(SUM), COUT, OVERFLOW);
				end
			end
		end
		$finish;
	end
endmodule	