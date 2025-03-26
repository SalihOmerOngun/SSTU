`timescale 1ns / 1ps

module DFF_sync
(
	input clk,
	input rst,
	input D,
	output Q
);

	reg Q_reg;
	
	always @(posedge clk) begin
		if(rst==1'b1) begin
			Q_reg <= 1'b0;
		end
		else begin
			Q_reg <= D;
		end
	end
	assign Q = Q_reg;
	
endmodule 	


module DFF_async
(
	input clk,
	input rst,
	input D,
	output Q
);

	reg Q_reg;
	
	always @(posedge clk, negedge rst) begin
		if(rst==1'b0) begin
			Q_reg <= 1'b0;
		end
		else begin
			Q_reg <= D;
		end
	end
	assign Q = Q_reg;
endmodule 	

module shift8
(
	input clk,
	input rst,
	input D,
	output [7:0] Q
);

	reg [7:0] Q_reg;
	
	always @(posedge clk) begin
		if(rst==1'b1) begin
			Q_reg <= 8'b0;
		end
		else begin
			Q_reg <= {Q_reg[6:0],D};
		end
	end
	assign Q = Q_reg;
endmodule 		


module clk_divider #(parameter [27:0] CLK_DIV = 100)
(
	input clk_in,
	input rst,
	output clk_out
);

	reg clk_out_reg;
	reg [27:0] counter;
	
	always @(posedge clk_in) begin
		if(rst==1'b1) begin
			clk_out_reg <= 1'b0;
			counter <= 28'b0;
		end
		else begin
			if(counter ==((CLK_DIV/2)-1))begin
				clk_out_reg <= ~clk_out; // clk_out_reg olmalı bence yanlışklıkla sildim galiba
				counter <= 28'b0;
			end
			else begin 
				counter <= counter + 1;
			end
		end	
	end
	assign clk_out = clk_out_reg;
endmodule	

module sliding_leds #(parameter [23:0] CLK_DIV = 10000000)     
(                      
	input clk,
	input rst,
	input [1:0] SW,
	output [15:0] LED
);

	reg [23:0] counter;
	reg [15:0] led_reg;
	
	always @(posedge clk, posedge rst) begin
		if(rst==1'b1) begin
			counter <= 24'b0;
			led_reg <= 16'b0000000000000001;
		end	
		else begin
			case(SW)
				2'b00:  led_reg <= led_reg;
				
				2'b01: begin
					if(counter == CLK_DIV -1) begin
						counter <= 24'b0;
						if(led_reg == 16'b1000000000000000) begin
							led_reg <= 16'b0000000000000001;
						end
						else begin
							led_reg <= led_reg << 1;
						end	
					end
					else begin
						counter <= counter + 1;	
					end
				end	
				
				2'b10: begin
					if(counter == (CLK_DIV/2) -1) begin
						counter <= 24'b0;
						if(led_reg == 16'b1000000000000000) begin
							led_reg <= 16'b0000000000000001;
						end
						else begin
							led_reg <= led_reg<<1;
						end	
					end
					else begin
						counter <= counter + 1;	
					end
				end
				
				2'b11: begin
					if(counter == (CLK_DIV/5) -1) begin
						counter <= 24'b0;
						if(led_reg == 16'b1000000000000000) begin
							led_reg <= 16'b0000000000000001;
						end
						else begin
							led_reg <= led_reg<<1;
						end	
					end
					else begin
						counter <= counter + 1;	
					end
				end				
			
				default:  led_reg <= led_reg;
			endcase	
		end
	end
		
	assign LED = led_reg;

endmodule	