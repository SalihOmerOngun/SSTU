`timescale 1ns / 1ps


module consec
(
	input clk,
	input rst,
	input x,
	output z
);
	reg q0,q1,q2;
	wire Q0,Q1,Q2,z_moore;
	reg z_reg;
	assign Q2 = (x & q2) | (x & q1 & q0);
	assign Q1 = (q1 & ~q0) | (x & ~q2 & ~q1) | (~q2 & ~q1 & q0);
	assign Q0 = (x & ~q1) | (~q0 & ~q1 & ~q2) | (x & ~q0);
	assign z_moore = (x & q2 & q0) | (~x & q1 & ~q0); 
	//assign z = (x & q2 & q0) | (~x & q1 & ~q0); 
	always @(posedge clk) begin // lab da olan fpga de clock butonu sıkıntılı. Rst verirken clk basılı kaldığı için rst den sonra z=0 olmuyor. Birden fazla clk basılmış oluyor rst yaparken.
		if(rst == 1'b1) begin
			q2 <= 1'b0;
			q1 <= 1'b0;
			q0 <= 1'b0;
		end
		else begin
			q2<= Q2;
			q1<= Q1;
			q0<= Q0;
			z_reg<= z_moore;
		end
	end
	assign z = z_reg;
endmodule	


