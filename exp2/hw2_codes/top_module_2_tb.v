`timescale 1ns / 1ps


module top_module_tb();

	reg [7:0] SW= 8'b0;
	reg [3:0] BTN= 4'b0;
	
	wire [7:0] LED; 
	wire [6:0] CAT;
	wire [3:0] AN;
	wire [0:0] DP;
	
	integer i;
	top_module uut
	(
		.sw(SW),
		.btn(BTN),
		.led(LED),
		.cat(CAT),
		.an(AN),
		.dp(DP)
	);
	
	initial
	begin
		/*
		SW[3:0] = 4'b0000; // decoder ve encoder
		#10;
		SW[3:0] = 4'b0001;
		#10;
		SW[3:0] = 4'b0010;
		#10;
		SW[3:0] = 4'b0011;
		#10;		
		SW[3:0] = 4'b0100;
		#10;		
		SW[3:0] = 4'b0101;
		#10;		
		SW[3:0] =4'b0110;
		#10;		
		SW[3:0] =4'b0111;
		#10;	
		SW[3:0] =4'b1000;
		#10;
		SW[3:0] =4'b1001;
		#10;
		SW[3:0] =4'b1010;
		#10;
		SW[3:0] =4'b1011;
		#10;
		SW[3:0] =4'b1100;
		#10;
		SW[3:0] =4'b1101;
		#10;
		SW[3:0] =4'b1110;
		#10;
		SW[3:0] =4'b1111;
		#10;	*/
		/*
		SW[3:0] = 4'b0001; // mux 
		BTN[1:0] = 2'b00;
		#10;
		SW[3:0] = 4'b1101;
		BTN[1:0] = 2'b01;
		#10;
		SW[3:0] = 4'b0100;
		BTN[1:0] = 2'b010;
		#10;		
		SW[3:0] = 4'b0111;
		BTN[1:0] = 2'b11;
		#10;
		SW[3:0] = 4'b1110;
		BTN[1:0] = 2'b00;
		#10;
		SW[3:0] = 4'b0010;
		BTN[1:0] = 2'b01;
		#10;
		SW[3:0] = 4'b1011;
		BTN[1:0] = 2'b010;
		#10;		
		SW[3:0] = 4'b1000;
		BTN[1:0] = 2'b11;
		#10;*/
		
		SW[0] = 1; // demux
		BTN[1:0] = 2'b00;
		#10;
		SW[0] = 1;
		BTN[1:0] = 2'b01;
		#10;
		SW[0] = 1;
		BTN[1:0] = 2'b10;
		#10;
		SW[0] = 1;
		BTN[1:0] = 2'b11;
		#10;
		$finish;
	end 
endmodule	
