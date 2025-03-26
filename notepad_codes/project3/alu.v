`timescale 1ns / 1ps


module ALU 
(
	input [1:0] insel,
	output [7:0] alu_out,
    input [7:0] alu_in_a,
    input [7:0] alu_in_b,
	output co,
	output z
);

	wire cout;
	wire [7:0] add_sum,shift_out,and_out,xor_out;
	wire shift_out_0;
	
	// ALU_OUT_MUX modülünün örneklemesi
    alu_out_mux alu_mux_inst (
        .D0(and_out),
        .D1(xor_out),
        .D2(add_sum),
        .D3(shift_out),
        .insel(insel),
        .O(alu_out)
    );

    // CO_MUX modülünün örneklemesi
    co_mux co_mux_inst (
        .D0(1'b0),
        .D1(1'b0),
        .D2(cout),
        .D3(shift_out_0),
        .insel(insel),
        .O(co)
    );
	
	AND and_8
	(
		.a(alu_in_a),
		.b(alu_in_b),
		.r(and_out)
	);
	
	XOR xor_8
	(
		.a(alu_in_a),
		.b(alu_in_b),
		.r(xor_out)
	);
	
	ADD add_8
	(
		.x(alu_in_a),
		.y(alu_in_b),
		.cin(1'b0),
		.cout(cout),
		.sum(add_sum)
	);

	circular_shift shift8
	(
		.a(alu_in_a),
		.r(shift_out),
		.r_0(shift_out_0)
	);

	zero_comp comparator8
	(
		.a(alu_out),
		.z(z)
	);
	

endmodule



module alu_out_mux (
    input [7:0] D0,
    input [7:0] D1,
    input [7:0] D2,
    input [7:0] D3,
    input [1:0] insel, // 2-bit seçim girişi
    output reg [7:0] O      // 4-bit çıkış
);

    always @(*)
    begin
        case (insel)
            2'b00: O = D0;
            2'b01: O = D1;
            2'b10: O = D2;
            2'b11: O = D3;
            default: O = 8'b0; // Güvenlik için bir default durumu ekledik
        endcase
    end

endmodule


module co_mux (
    input D0,
    input D1,
    input D2,
    input D3,
    input [1:0] insel, // 2-bit seçim girişi
    output reg O      // 4-bit çıkış
);

    always @(*)
    begin
        case (insel)
            2'b00: O = D0;
            2'b01: O = D1;
            2'b10: O = D2;
            2'b11: O = D3;
            default: O = 0; // Güvenlik için bir default durumu ekledik
        endcase
    end

endmodule


module circular_shift
(
	input [7:0] a ,
	output [7:0] r,
	output r_0
);

	assign r = {a[6:0],a[7]};
	assign r_0 = r[0]; 

endmodule 

module XOR(
    input [7:0] a,
    input [7:0] b,
    output [7:0] r);
    
    assign r = a ^ b;
endmodule

module AND(
    input [7:0] a,
    input [7:0] b,
    output [7:0] r
    );
    assign r = a & b;
endmodule


module ADD
(
	input [7:0] x,
	input [7:0] y,
	input cin,
	output cout,
	output [7:0] sum
);
	wire [8:0] cout_gen;
	
	assign cout_gen[0] = cin;
	
	genvar i;
	generate
		for(i = 0; i<8; i = i+1) begin : gen_full_adder
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
	assign cout = cout_gen[8];
	
endmodule	


module HA
(
	input x,
	input y,
	output cout,
	output sum
);
	reg sum_reg,cout_reg;
	
	always@(x,y) begin
		{cout_reg,sum_reg} = x + y;
	end

	assign sum = sum_reg;
	assign cout = cout_reg;
	
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


module zero_comp
(
	input [7:0] a,
	output reg z
);
	always @(*) begin
		if (a == 8'b0) begin
			z <= 1;
		end
		else begin 
			z <= 0;
		end
	end
endmodule	
	
	