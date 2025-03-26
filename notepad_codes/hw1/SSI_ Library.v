`timescale 1ns / 1ps

module Top_Module
(
 input [15:0]IN,
 output [7:0]OUT

);

	AND s1
	(
	.l1(IN[0]),
	.l2(IN[1]),
	.O(OUT[0])
	);

	OR s2
	(
	.l1(IN[2]),
	.l2(IN[3]),
	.O(OUT[1])
	);

	NOT s3
	(
	.I(IN[4]),
	.O(OUT[2])
	);

	NAND s4
	(
	.l1(IN[5]),
	.l2(IN[6]),
	.O(OUT[3])
	);

	NOR s5
	(
	.l1(IN[7]),
	.l2(IN[8]),
	.O(OUT[4])
	);

	EXOR s6
	(
	.l1(IN[9]),
	.l2(IN[10]),
	.O(OUT[5])
	);
	
	EXNOR s7
	(
	.l1(IN[11]),
	.l2(IN[12]),
	.O(OUT[6])
	);	
	
	TRI s8
	(
	.I(IN[13]),
	.E(IN[14]),
	.O(OUT[7])
	);	
	
endmodule

module AND
(
	input l1,
	input l2,
	output O
);

	assign O = l1 & l2;
	
endmodule	

module OR
(
	input l1,
	input l2,
	output O
);

	assign O = l1 | l2;
	
endmodule	

module NOT
(
	input I,
	output O
);

	assign O = ~I ;
	
endmodule	


module NAND
(
	input l1,
	input l2,
	output O
);
	reg O_reg; 

	always@(*)
	begin
		
		O_reg = ~ ( l1 & l2);
	end
	
	assign O = O_reg;
	
endmodule	


module NOR
(
	input l1,
	input l2,
	output O
);
	reg O_reg; 

	always@(*)
	begin
		
		O_reg = ~ ( l1 | l2);
	end
	
	assign O = O_reg;
	
endmodule	


module EXOR
(
	input l1,
	input l2,
	output O
);

 LUT2 #(
    .INIT ( 4'b0110 ) 
	) EXOR
	(
    .I0( l1 ),
    .I1( l2 ),
    .O ( O )
 );


endmodule	


module EXNOR
(
	input l1,
	input l2,
	output O
);

 LUT2 #(
    .INIT ( 4'b1001 ) 
	) EXNOR
	(
    .I0( l1 ),
    .I1( l2 ),
    .O ( O )
 );


endmodule	


module TRI
(
	input I,
	input E,
	output O
);

	assign O = (E == 1'b1) ? I : 1'bZ;
	
endmodule	