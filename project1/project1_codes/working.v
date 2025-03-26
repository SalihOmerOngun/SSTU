`timescale 1ns / 1ps

(* DONT_TOUCH = "TRUE" *)
module calc_hamming
(
	input [31:0] DATA,
	output [5:0] RESULT
);
	wire [2:0] sum_ham [7:0];
	reg [5:0] res_reg;
    integer j;
	genvar i;
	generate
		for(i = 0; i<8; i = i+1) begin : gen_part
			slice_adder gen_slice
			(
				DATA[i*4 +:4],
				sum_ham[i]
			);
		end
	endgenerate	
    always @(*) begin
        res_reg = 6'b0; 
        for (j = 0; j < 8; j = j + 1) begin
            res_reg = res_reg + sum_ham[j];
        end
    end
    assign RESULT = res_reg;
endmodule	

module slice_adder
(
	input [3:0] slice,
	output [2:0] sum
);

	wire [1:0] half_sum1; 
	wire [1:0] half_sum2;

	HA half1
	(
	  .x(slice[0]),
	  .y(slice[1]),
	  .sum(half_sum1[0]),
	  .cout(half_sum1[1])
	);

	HA half2
	(
	  .x(slice[2]),
	  .y(slice[3]),
	  .sum(half_sum2[0]),
	  .cout(half_sum2[1])
	);

	parametric_RCA para1
	(
		.x(half_sum1),
		.y(half_sum2),
		.cin(0),
		.cout(sum[2]),
		.sum(sum[1:0])
	);

endmodule



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

module OR
(
	input l1,
	input l2,
	output O
);

	assign O = l1 | l2;
	
endmodule	

module parametric_RCA 
(
	input [1:0] x,
	input [1:0] y,
	input cin,
	output cout,
	output [1:0] sum
);

	wire [2:0] cout_gen;
	
	assign cout_gen[0] = cin;
	
	genvar i;
	generate
		for(i = 0; i<2; i = i+1) begin : gen_full_adder
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
	assign cout = cout_gen[2];
	
endmodule





