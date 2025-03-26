`timescale 1ns/1ps

module top_module
(
	input clk,
	input rst,
    input [7:0] inA,
    input [7:0] inB,
	input start,
	output busy,
	output [7:0] out 
);
	wire co;
	wire z;
	wire [1:0] insel;
	wire [7:0] cu_const;
	wire [2:0] in_mux_add;
	wire [3:0] out_mux_add;
	wire [3:0] reg_add;
	wire we;
    wire [7:0] alu_out;
    wire [7:0] alu_in_a;
    wire [7:0] alu_in_b;
	
	wire [4:0] cu_state = cu.state ;
	control_unit cu 
	(
		.clk(clk),
		.rst(rst),
		.start(start),
		.co(co),
		.z(z),
		.busy(busy),
		.insel(insel),
		.cu_const(cu_const),
		.in_mux_add(in_mux_add),
		.out_mux_add(out_mux_add),
		.reg_add(reg_add),
		.we(we)
	);
	wire [7:0] re_out0 = rb.re_out0; 
	wire [7:0] re_out1 = rb.re_out1; 
	wire [7:0] re_out2 = rb.re_out2; 
	wire [7:0] re_out3 = rb.re_out3; 
	wire [7:0] re_out4 = rb.re_out4; 
	wire [7:0] re_out5 = rb.re_out5;
	wire [7:0] re_out6 = rb.re_out6;
	wire [7:0] out_mux_out = rb.out_mux_out;
    wire [7:0] in_mux_out = rb.in_mux_out;
	    REGISTER_BLOCK rb
		(
        .clk(clk),
        .rst(rst),
        .inA(inA),
        .inB(inB),
        .cu_const(cu_const),
        .in_mux_add(in_mux_add),
        .out_mux_add(out_mux_add),
        .reg_add(reg_add),
        .we(we),
        .alu_out(alu_out),
        .alu_in_a(alu_in_a),
        .alu_in_b(alu_in_b),
        .out(out)
    );

	wire [7:0] add_sum = alu.add_sum;
	ALU alu
	(
		.insel(insel),
		.alu_in_a(alu_in_a),
		.alu_in_b(alu_in_b),
		.alu_out(alu_out),
		.co(co),
		.z(z)
    );


endmodule 