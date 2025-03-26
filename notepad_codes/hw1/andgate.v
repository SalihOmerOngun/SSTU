`timescale 1ns / 1ps

module andgate
(
	input l1,
	input l2,
	output o
);

	assign o = l1 & l2;
	
endmodule	