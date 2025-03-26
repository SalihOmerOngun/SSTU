`timescale 1ns / 1ps

module top_module
(
	input [7:0] sw,
	input [3:0] btn,
	output [7:0] led,
	output [6:0] cat,
	output [3:0] an,
	output [0:0] dp

);

/*
	DECODER decoder1
	(
		.IN(sw[3:0]),
		.OUT({dp, cat, led})
	);
		
		assign an = 4'b1110;*/
		
	/*
	ENCODER encoder1
	(
		.IN(sw[3:0]),
		.OUT(led[1:0]),
		.V(led[7])
	);*/
	
	/*
	MUX  mux1
	(
		.D(sw[3:0]),
		.S(btn[1:0]),
		.O(led[0])
	);*/
	
	
	DEMUX demux1
	(
		.D(sw[0]),
		.S(btn[1:0]),
		.O(led[3:0])
	);
	
endmodule		