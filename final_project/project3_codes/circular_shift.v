`timescale 1ns / 1ps

module circular_shift
(
	input [7:0] a ,
	output [7:0] r,
	output r_0
);

	assign r = {a[6:0],a[7]};
	assign r_0 = r[0]; 

endmodule 