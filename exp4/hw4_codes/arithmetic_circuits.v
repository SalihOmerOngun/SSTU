`timescale 1ns / 1ps
	

module HA
(
	input x,
	input y,
	output cout,
	output sum
);
	assign sum = x ^ y ;
	assign cout = x & y;
	
endmodule 	


module FA
(
	input x,
	input y,
	input cin,
	output cout,
	output sum
);
	wire ha1_sum, ha1_cout, ha2_cout;
	
	HA half1
	(
	  .x(x),
	  .y(y),
	  .sum(ha1_sum),
	  .cout(ha1_cout)
	);

	HA half2
	(
		.x(ha1_sum),
		.y(cin),
		.sum(sum),
		.cout(ha2_cout)
	);
	
	OR or1
	(
	.l1(ha1_cout),
	.l2(ha2_cout),
	.O(cout)
	);

endmodule 	


module RCA
(
	input [3:0] x,
	input [3:0] y,
	input cin,
	output cout,
	output [3:0] sum
);
	wire cout1,cout2,cout3;
	
	FA fa1
	(
		.x(x[0]),
		.y(y[0]),
		.cin(cin),
		.sum(sum[0]),
		.cout(cout1)
	);

	FA fa2
	(
		.x(x[1]),
		.y(y[1]),
		.cin(cout1),
		.sum(sum[1]),
		.cout(cout2)
	);

	FA fa3
	(
		.x(x[2]),
		.y(y[2]),
		.cin(cout2),
		.sum(sum[2]),
		.cout(cout3)
	);
	
	FA fa4
	(
		.x(x[3]),
		.y(y[3]),
		.cin(cout3),
		.sum(sum[3]),
		.cout(cout)
	);	
endmodule 	


module parametric_RCA #(parameter SIZE = 8)
(
	input [SIZE-1:0] x,
	input [SIZE-1:0] y,
	input cin,
	output cout,
	output [SIZE-1:0] sum
);

	wire [SIZE:0] cout_gen;
	
	assign cout_gen[0] = cin;
	
	genvar i;
	generate
		for(i = 0; i<SIZE; i = i+1) begin : gen_full_adder
			FA gen_full
			(
				x[i],
				y[i],
				cout_gen[i],
				cout_gen[i+1],
				sum[i]
		    );
		end 	
	endgenerate
	assign cout = cout_gen[SIZE];
	
endmodule	

	
module CLA #(parameter SIZE = 8)
(
	input [SIZE-1:0] x,
	input [SIZE-1:0] y,
	input cin,
	output cout,
	output [SIZE-1:0] s
	
);

	wire [SIZE:0] p;
	wire [SIZE:0] g;
	
	wire [SIZE+1:0] c;
	assign c[0] = cin;
	
	genvar i;
	genvar j;
	generate // generate bloğu olmadan for loop içerisinde assign kullanımına izin vermiyor. assign olmadan da atama yapılamıyor. generate+assign yada always kullanacaksın. 
		for(i = 0; i<SIZE; i = i+1) begin: gen_p_g
            assign p[i] = x[i] ^ y[i];
            assign g[i] = x[i] & y[i]; 
		end 	
		
	endgenerate
	
	generate
        for(j = 0; j<SIZE+1; j = j+1) begin : gen_c
            assign c[j+1] = g[j]|(p[j] & c[j]); 	
        end	
	endgenerate
		
	assign cout = c[SIZE];

    generate
        for(j = 0; j<SIZE; j = j+1) begin: gen_s
            assign s[j] = p[j] ^ c[j]; 	
        end	
	endgenerate
endmodule	

(* DONT_TOUCH = "yes" *)
module Behav_adder #(parameter SIZE = 8)
(
	input [SIZE-1:0] x,
	input [SIZE-1:0] y,
	output cout,
	output [SIZE-1:0] sum
);
	assign {cout,sum} = x + y;
	
endmodule	

module Add_Sub
(
	input [3:0] A,
	input [3:0] B,
	input cin,
	output [3:0] sum,
	output cout,
	output overflow
);

	wire [3:0] b_xor;
	wire [4:0] c_gen;
	assign c_gen[0] = cin;
	
	genvar i;
	
	
	generate
		for(i = 0; i<4; i=i+1) begin: gen_xor
			assign b_xor[i] = B[i] ^ cin ;
		end	
		
		for(i = 0; i<4; i=i+1) begin: gen_full	
			FA gen_full
			(
				A[i],
				b_xor[i],
				c_gen[i],
				c_gen[i+1],
				sum[i]
		    );
		end
	endgenerate

	assign cout = c_gen[4];

	assign overflow = c_gen[4] ^ c_gen[3];
endmodule	


module DSP_IMP 
(
    input clk,
    input [1:0] a,
    input [1:0] b,
    input [1:0] c,
    output [3:0] result
);
	reg [3:0] result_reg;

    always @(posedge clk) begin
        result_reg <= (a * b) + c; 
    end
	
	assign result = result_reg;
	
endmodule
