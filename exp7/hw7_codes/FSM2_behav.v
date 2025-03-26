`timescale 1ns / 1ps



module div_behav
(
	input clk,
	input rst,
	input x,
	output z
);
	reg z_reg,a,x_cs;
	localparam A = 2'b00;
	localparam B = 2'b01;
	localparam C = 2'b10;	
	reg [1:0] state;
	
	always@(*) begin
		a<= ~(x_cs ^ x);
	end
	
	always @(posedge clk, posedge rst) begin
		if(rst == 1) begin
            state <= A;
			//a<=0;
			//x_cs<=0;
        end
		else begin
			x_cs<=x;
			case(state)
				A : begin
                    if(a==1) begin
                        state <= B;
					end	
                    else begin
                        state <= A;                        
					end
                    z_reg<= 0;
                end
				B: begin
					if(a==1) begin
						state<= C;
					end
					else begin
						state<= A;
					end
					z_reg<=0;
				end
				C: begin
					if(a==1) begin
						state<= C;
						z_reg<= 1;
					end
					else begin
						state<= A;
						z_reg<=0;
					end
				end		
                default: begin
                    state <= A;                        
                    z_reg<= 0;                         
                end								
			endcase
		end
	end	
	assign z = z_reg;	
endmodule	
	