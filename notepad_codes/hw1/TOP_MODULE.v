`timescale 1ns / 1ps

module Top_Module // bunu kullanmadık bence SSI daki top module kullandık
(
 input [15:0]IN,
 output [7:0]OUT

);

andgate A1
(
	.l1(IN[0]),
	.l2(IN[1]),
	.o(OUT[0])
);	

endmodule