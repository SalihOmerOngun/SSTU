`timescale 1ns / 1ps


module divide
(
	input clk,
	input rst,
	input x,
	output z
);
	reg q0,q1,x_cs,z_reg;
	wire Q0,Q1,a,z_moore; 
	assign Q1 = (a & q1) | (a & q0) ;
	assign Q0 = (a & ~q1 & ~q0); 
	assign a = ~(x_cs ^ x);
	assign z_moore = (a & q1);	
	always @(posedge clk) begin
		if(rst == 1'b1) begin
			q1 <= 1'b0;
			q0 <= 1'b0;

		end
		else begin
			q1 <= Q1;
			q0 <= Q0;
			x_cs<= x;
			z_reg<= z_moore;
		end
	end
	assign z = z_reg;
endmodule	

