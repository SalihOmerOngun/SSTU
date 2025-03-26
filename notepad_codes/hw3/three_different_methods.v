`timescale 1ns / 1ps


module with_SSI
(
	input a,
	input b,
	input c,
	input d,
	output f3,
	output f2,
	output f1,
	output f0
);

	wire a_d_and,b_c_and,a_c_and;
	wire b_not,d_not;
	wire b_not_d_not_or;
	
	AND and1 //f0
	(
		.l1(b),
		.l2(d),
		.O(f0)
	);
	
	AND and2 // for f1
	(
		.l1(a),
		.l2(d),
		.O(a_d_and)
	);	
	
	AND and3 // for f1
	(
		.l1(b),
		.l2(c),
		.O(b_c_and)
	);		
	

	EXOR xor1 //f1
	(
	.l1(a_d_and),
	.l2(b_c_and),
	.O(f1)
	);	
	

	NOT not1 // for f2
	(
		.I(b),
		.O(b_not)
	);
	
	NOT not2 //for f2
	(
		.I(d),
		.O(d_not)
	);	
	
	AND and4 // for f2
	(
		.l1(a),
		.l2(c),
		.O(a_c_and)
	);		
	
	OR or1 // for f2
	(
	.l1(b_not),
	.l2(d_not),
	.O(b_not_d_not_or)
	);	
	
	AND and5 // f2
	(
		.l1(a_c_and),
		.l2(b_not_d_not_or),
		.O(f2)
	);	
	
	AND and6 // f3
	(
		.l1(a_d_and),
		.l2(b_c_and),
		.O(f3)
	);		
	
endmodule	


module with_decoder
(
	input a,
	input b,
	input c,
	input d,
	output f3,
	output f2,
	output f1,
	output f0
);
	wire [15:0] f_out;

	DECODER decoder1
	(
		.IN({a,b,c,d}),
		.OUT(f_out)
	);
	
	wire m5_7,m13_15;
	wire m6_7,m9_11,m13_14,m6_7_or_m9_11;
	wire m10_11;
	OR de1 // for f0
	(
	.l1(f_out[5]),
	.l2(f_out[7]),
	.O(m5_7)
	);	
	
	OR de2 // for f0
	(
	.l1(f_out[13]),
	.l2(f_out[15]),
	.O(m13_15)
	);	
	
	OR de3 // f0
	(
	.l1(m5_7),
	.l2(m13_15),
	.O(f0)
	);		
	
	OR de4 // for f1
	(
	.l1(f_out[6]),
	.l2(f_out[7]),
	.O(m6_7)
	);		
	
	OR de5 // for f1
	(
	.l1(f_out[9]),
	.l2(f_out[11]),
	.O(m9_11)
	);		
	
	OR de6 // for f1
	(
	.l1(f_out[13]),
	.l2(f_out[14]),
	.O(m13_14)
	);	
	
	OR de7 // for f1
	(
	.l1(m6_7),
	.l2(m9_11),
	.O(m6_7_or_m9_11)
	);	
	
	OR de8 // for f1
	(
	.l1(m13_14),
	.l2(m6_7_or_m9_11),
	.O(f1)
	);		
	
	OR de9 // for f2
	(
	.l1(f_out[10]),
	.l2(f_out[11]),
	.O(m10_11)
	);
	
	OR de10 // f2
	(
	.l1(m10_11),
	.l2(f_out[14]),
	.O(f2)
	);	
	
	assign f3 = f_out[15];
	
endmodule	

module with_MUX
(
	input a,
	input b,
	input c,
	input d,
	output f3,
	output f2,
	output f1,
	output f0
);
	wire b_d_and;
	wire b_d_xor;
	wire b_not,d_not,b_not_d_not_or;
	
	AND and7 // for f0
	(
		.l1(b),
		.l2(d),
		.O(b_d_and)
	);

	MUX  mux0 // f0
	(
		.D({4{b_d_and}}),
		.S({a,c}),
		.O(f0)
	);
	
	EXOR xor2 //for f1
	(
	.l1(b),
	.l2(d),
	.O(b_d_xor)
	);		
	
	MUX  mux1 // f1
	(
		.D({b_d_xor,d,b,1'b0}),
		.S({a,c}),
		.O(f1)
	);
	
	NOT not3 //for f2
	(
		.I(d),
		.O(d_not)
	);		
	
	NOT not4 //for f2
	(
		.I(b),
		.O(b_not)
	);		
	
	OR de11 // for f2
	(
	.l1(b_not),
	.l2(d_not),
	.O(b_not_d_not_or)
	);		
	
	MUX  mux2 // f2
	(
		.D({b_not_d_not_or,3'b000}),
		.S({a,c}),
		.O(f2)
	);	
	
	AND and8 // for f3
	(
		.l1(b),
		.l2(d),
		.O(b_d_and)
	);	
	
	MUX  mux3 // f3
	(
		.D({b_d_and,3'b000}),
		.S({a,c}),
		.O(f3)
	);		
	
	
endmodule	