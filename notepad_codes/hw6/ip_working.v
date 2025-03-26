`timescale 1ns / 1ps



module clock_gen
(
	input clk,
	input rst,
	output [6:0] cnt100,
	output [6:0] cnt80,
	output [6:0] cnt60	
);
	wire clk80;
	wire clk60;
	reg [6:0] cnt100_reg;
	reg [6:0] cnt80_reg;
	reg [6:0] cnt60_reg;
	
	clk_wiz_0 instance_name
	(
		// Clock out ports
		.clk_out1(clk80),     // output clk_out1 80MHz
		.clk_out2(clk60),     // output clk_out2 60MHz
		// Status and control signals
		.reset(rst), // input reset
		.locked(locked),       // output locked
	   // Clock in ports
		.clk_in1(clk)      // input clk_in1
	);
	
	always @(posedge clk) begin
		if(rst==1'b1) begin
			cnt100_reg <= 7'b0;
		end
		else if(locked ==1'b1) begin
			if(cnt100_reg < 100) begin
				cnt100_reg <= cnt100_reg + 1;
			end
			else begin
				cnt100_reg <= cnt100_reg;
			end	
		end
	end
	assign cnt100 = cnt100_reg;
	
	always @(posedge clk80) begin
		if(rst==1'b1) begin
			cnt80_reg <= 7'b0;
		end
		else if(locked ==1'b1) begin
			if(cnt80_reg < 80) begin
				cnt80_reg <= cnt80_reg + 1;
			end
			else begin
				cnt80_reg <= cnt80_reg;
			end	
		end	
	end
	assign cnt80 = cnt80_reg;
	
	always @(posedge clk60) begin
		if(rst==1'b1) begin
			cnt60_reg <= 7'b0;
		end
		else if(locked ==1'b1) begin
			if(cnt60_reg < 60) begin
				cnt60_reg <= cnt60_reg + 1;
			end
			else begin
				cnt60_reg <= cnt60_reg;
			end	
		end	
	end
	assign cnt60 = cnt60_reg;
	
endmodule	


module clock_gating
(
	input clk,
	input rst,
	output [6:0] cnt50,
	output [6:0] cnt25
);

	reg clk50_en,clk25_en;
	wire clk50,clk25;
	reg [6:0] cnt50_reg;
	reg [6:0] cnt25_reg;	

	BUFR #(					// 50MHz
	   .BUFR_DIVIDE("2"),   	
	   .SIM_DEVICE("7SERIES")   
	)
	BUFR_inst50 (
	   .O(clk50),     
	   .CE(clk50_en),   
	   .CLR(1'b0), 
	   .I(clk)       
	);	

	BUFR #(					// 25MHz
	   .BUFR_DIVIDE("4"),   	
	   .SIM_DEVICE("7SERIES")  
	)
	BUFR_inst25 (
	   .O(clk25),      
	   .CE(clk25_en),    // 1-bit input: Active high, clock enable (Divided modes only)
	   .CLR(1'b0), // 1-bit input: Active high, asynchronous clear (Divided modes only)
	   .I(clk)       
	);	
	
	always @(posedge clk50, posedge rst) begin
		if(rst==1'b1) begin
			clk50_en <= 1'b1;
			cnt50_reg <= 7'b0;
		end
		else if(clk50_en == 1'b1)begin
			if(cnt50_reg < 50) begin
				cnt50_reg <= cnt50_reg + 1;
			end
			else begin
				clk50_en <= 1'b0;	
			end	
		end	
	end
	assign cnt50 = cnt50_reg;
	
	always @(posedge clk25, posedge rst) begin
		if(rst==1'b1) begin
			clk25_en <= 1'b1;
			cnt25_reg <= 7'b0;
		end
		else if(clk25_en == 1'b1)begin
			if(cnt25_reg < 25) begin
				cnt25_reg <= cnt25_reg + 1;
			end
			else begin
				clk25_en <= 1'b0;
			end
		end	
	end
	assign cnt25 = cnt25_reg;
endmodule		

module block_ram
(
	input clka,
	input wea,
	input [3:0] addra,
	input [7:0] dina,
	output [7:0] douta
);

	wire clk_50;
	blk_mem_gen_0 your_instance_name 
	(
	  .clka(clk_50),    // input wire clka
	  .wea(wea),      // input wire [0 : 0] wea
	  .addra(addra),  // input wire [3 : 0] addra
	  .dina(dina),    // input wire [7 : 0] dina
	  .douta(douta)  // output wire [7 : 0] douta
	);

   clk_wiz_2 instance_name
   (
    // Clock out ports
    .clk_50(clk_50),     // output clk_50
    // Status and control signals
    .reset(reset), // input reset
    .locked(locked),       // output locked
   // Clock in ports
    .clk_in1(clka)      // input clk_in1
	);
	
endmodule	


module FIFO
(
	input clk,
	input rst,
	input wr_en,
	input rd_en,
	input [7:0] din,
	output [7:0] dout,
	output empty,
	output full,
	output overflow,
	output underflow

);

	wire clk_50,clk_25;

	fifo_generator_0 your_instance_name 
	(
	  .wr_clk(clk_50),        // input wire wr_clk
	  .wr_rst(rst),        // input wire wr_rst
	  .rd_clk(clk_25),        // input wire rd_clk
	  .rd_rst(rst),        // input wire rd_rst
	  .din(din),              // input wire [7 : 0] din
	  .wr_en(wr_en),          // input wire wr_en
	  .rd_en(rd_en),          // input wire rd_en
	  .dout(dout),            // output wire [7 : 0] dout
	  .full(full),            // output wire full
	  .overflow(overflow),    // output wire overflow
	  .empty(empty),          // output wire empty
	  .underflow(underflow)  // output wire underflow
	);
	
	
   clk_wiz_3 instance_name
   (
    // Clock out ports
    .clk_50(clk_50),     // output clk_50
    .clk_25(clk_25),     // output clk_25
    // Status and control signals
    .reset(reset), // input reset
    .locked(locked),       // output locked
   // Clock in ports
    .clk_in1(clk)      // input clk_in1
	);	
	
endmodule	