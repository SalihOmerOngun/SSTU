`timescale 1ns / 1ps

module DECODER
(
	input [3:0] IN,
	output [15:0] OUT

);

	reg [15:0] out_reg;
	
	always@(*)
	begin
		case(IN)
			4'b0000: out_reg = 16'b0000_0000_0000_0001;
			4'b0001: out_reg = 16'b0000_0000_0000_0010;
            4'b0010: out_reg = 16'b0000_0000_0000_0100;
            4'b0011: out_reg = 16'b0000_0000_0000_1000;
            4'b0100: out_reg = 16'b0000_0000_0001_0000;
            4'b0101: out_reg = 16'b0000_0000_0010_0000;
            4'b0110: out_reg = 16'b0000_0000_0100_0000;
            4'b0111: out_reg = 16'b0000_0000_1000_0000;
            4'b1000: out_reg = 16'b0000_0001_0000_0000;
            4'b1001: out_reg = 16'b0000_0010_0000_0000;
            4'b1010: out_reg = 16'b0000_0100_0000_0000;
            4'b1011: out_reg = 16'b0000_1000_0000_0000;
            4'b1100: out_reg = 16'b0001_0000_0000_0000;
            4'b1101: out_reg = 16'b0010_0000_0000_0000;
            4'b1110: out_reg = 16'b0100_0000_0000_0000;
            4'b1111: out_reg = 16'b1000_0000_0000_0000;
            default: out_reg = 16'b0000_0000_0000_0000;
		endcase
	end
	
	assign OUT = out_reg;

endmodule	
	
/*	
module ENCODER
(
	input [3:0] IN,
	output [1:0] OUT,
	output V
);	

	assign V = IN[0] | IN[1] | IN[2] | IN[3] ;
	assign OUT[0] = IN[3] | ( IN[1] & ~(IN[2]) ) ;
	assign OUT[1] = IN[3] | IN[2]  ;

endmodule */

module ENCODER
(
	input [3:0] IN,
	output [1:0] OUT,
	output V
);
	reg V_reg;
	reg [1:0] OUT_reg;
	
	always@(*)
	begin
		casex(IN)
			4'b0000:
			begin
				V_reg = 0;
				OUT_reg = 2'bxx;
			end
			
			4'b0001:
			begin
				V_reg = 1;
				OUT_reg = 2'b00;
			end
			
			4'b001x:
			begin
				V_reg = 1;
				OUT_reg = 2'b01;
			end
			
			4'b01xx:
			begin
				V_reg = 1;
				OUT_reg = 2'b10;
			end		
			
			4'b1xxx:
			begin
				V_reg = 1;
				OUT_reg = 2'b11;
			end		
		endcase
		
	end
	
	assign OUT = OUT_reg;
	assign V = V_reg;
	
	
endmodule	

/*
module MUX
(

	input [3:0] D,
	input [1:0] S,
	output O
);

	assign O = (S[0] == 1'b0) ? 
			   (S[1] == 1'b0) ? D[0] : D[2]:
			   (S[1] == 1'b0) ? D[1] : D[3];
			   
			   
endmodule		*/	   


module MUX
(
	input [3:0] D,
	input [1:0] S,
	output O
);

	reg O_reg; 
	
	always@(*)
	begin 
		case(S)
			2'b00 : O_reg = D[0];
			2'b01 : O_reg = D[1];
			2'b10 : O_reg = D[2];
			2'b11 : O_reg = D[3];
		endcase
	end		
	
	assign O = O_reg;
	
endmodule	

module DEMUX 
(
	input D,
	input [1:0] S,
	output [3:0] O
);

	wire and_o_0,and_o_1,and_o_2,and_o_3;
	wire s0_not_o,s1_not_o;
	
	NOT s0_not
	(
		.I(S[0]),
		.O(s0_not_o)
	);
	
	NOT s1_not
	(
		.I(S[1]),
		.O(s1_not_o)
	);
	
	AND and0
	(
		.l1(s0_not_o),
		.l2(s1_not_o),
		.O(and_o_0)
	);
	
	AND and1
	(
		.l1(S[0]),
		.l2(s1_not_o),
		.O(and_o_1)
	);

	AND and2
	(
		.l1(s0_not_o),
		.l2(S[1]),
		.O(and_o_2)
	);

	AND and3
	(
		.l1(S[0]),
		.l2(S[1]),
		.O(and_o_3)
	);
	
	TRI tri_0
	(
	.I(D),
	.E(and_o_0),
	.O(O[0])
	);	
	
	TRI tri_1
	(
	.I(D),
	.E(and_o_1),
	.O(O[1])
	);	
	
	TRI tri_2
	(
	.I(D),
	.E(and_o_2),
	.O(O[2])
	);	
	
	TRI tri_3
	(
	.I(D),
	.E(and_o_3),
	.O(O[3])
	);	
	
endmodule
	