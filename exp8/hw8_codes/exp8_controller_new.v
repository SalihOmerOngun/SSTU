



module controller  // 3 tane bram den gelecek (red green blue) 
(
	input pixel_clk,
	input rst,
	input enable,
	input [11:0] data_in, // bram douta dan veri alınacak
	output reg done,
	output reg [16:0] address, // bram kontrol edilecek   bram eee eef a99 gibi tek satırı veriyor bir indexte 
	output  signed [11:0] kernel1,
	output  signed [11:0] kernel2,
	output  signed [11:0] kernel3,
	output reg  [11:0] pixel1,
	output reg  [11:0] pixel2,
	output reg  [11:0] pixel3
);
	assign kernel1 = 12'b0001_0001_0001; 
	assign kernel2 = 12'b0001_1000_0001;
	assign kernel3 = 12'b0001_0001_0001;
	reg [11:0] buffer1[641:0];
	reg [11:0] buffer2[641:0];
	reg [9:0] counter;
	reg [9:0] sel_column;
	reg [7:0] column;
	reg [8:0] row;
	reg [11:0] prev_data
	localparam FIRST_LINE = 3'b000;
	localparam SHIFT1 = 3'b001;
	localparam SHIFT2 = 3'b010;
	localparam SHIFT3 = 3'b011;
	localparam OTHER_ROWS = 3'b100;
	localparam DONE = 3'b101;
	reg [2:0] state;
	

	
	always @(posedge pixel_clk) begin
	
		if (rst == 1'b1) begin
			state <= FIRST_LINE;
			counter <= 10'd0;
			sel_column <= 12'd0;
			column <= 8'd0;
			row <= 9'd2;
			done <= 1'b0;
		end
		else begin                                                   
			if(enable  == 1'b1) begin
				case(state)                                            
					FIRST_LINE: begin	
						done <= 1'b0;
						address <= 17'd0;
						buffer1[counter] <= data_in[11:8];   // index tut her clk da bir eleman yazdır
						buffer1[(counter + 1] <= data_in[7:4];
						buffer1[(counter + 2] <= data_in[3:0];
						if(counter == 10'd639) begin
							counter <= 10'd0;
							state <= SECOND_LINE;
						end
						else begin 
							counter <= counter + 1;
						end	
					end																					
					
					SECOND_LINE: begin	
						address <= 17'd214;
						buffer2[counter] <= data_in[11:8];
						buffer2[(counter + 1] <= data_in[7:4];
						buffer2[(counter + 2] <= data_in[3:0];
						if(counter == 10'd639) begin
							counter <= 10'd0;
							state <= SHIFT1;
						end
						else begin 
							counter < counter + 1;
						end															
					end	
					
					
					SHIFT1: begin
						address <= (214 * row) + column; // 428 den baslar
						pixel1 <= {buffer1[sel_column],buffer1[sel_column + 1],buffer1[sel_column + 2]};
						pixel2 <= {buffer2[sel_column],buffer2[sel_column + 1],buffer2[sel_column + 2]};
						pixel3 <= data_in;
						if(sel_column == 10'd639) begin
							if(row == 9'd481) begin
								state <=DONE;
							end	
							else begin
								row <= row + 1;
							end	
							sel_column <= 10'd0;
							column <= 8'd0;
							state <= SHIFT1;
						end
						else begin
							prev_data <= data_in;
							state <= SHIFT2
							sel_column <= sel_column + 1;
							column <= column + 1
						end
					end	
					
					SHIFT2: begin
					
						address <= (214 * row) + column; // 3 0,
						pixel1 <= {buffer1[sel_column],buffer1[sel_column + 1],buffer1[sel_column + 2]};
						pixel2 <= {buffer2[sel_column],buffer2[sel_column + 1],buffer2[sel_column + 2]};
						pixel3 <= {prev_data[7:0],data_in[11:8]];
						state <= SHIFT3
						sel_column <= sel_column + 1;

					end	
					
					SHIFT3: begin
						pixel1 <= {buffer1[sel_column],buffer1[sel_column + 1],buffer1[sel_column + 2]};
						pixel2 <= {buffer2[sel_column],buffer2[sel_column + 1],buffer2[sel_column + 2]};
						pixel3 <= {prev_data[3:0],data_in[11:4]];

						buffer2[sel_column - 2] <= prev[11:8];
						buffer2[sel_column - 1] <= prev[7:4];
						buffer2[sel_column ] <= prev[3:0];
						buffer1[sel_column]     <= buffer2[sel_column];
						buffer1[sel_column - 1] <= buffer2[sel_column - 1];
						buffer1[sel_column - 2] <= buffer2[sel_column - 2];
						
						state <= SHIFT1
						sel_column <= sel_column + 1;

					end						

					DONE: begin
						state <= FIRST_LINE;
						counter <= 10'd0;
						sel_column <= 12'd0;
						column <= 8'd0;
						row <= 9'd2;
						done <= 1'b1;
					
					end
					
					
					default: begin
						state <= FIRST_LINE;
						counter <= 10'd0;
						sel_column <= 12'd0;
						column <= 8'd0;
						row <= 9'd2;
						done <= 1'b0;
					end
					
				endcase
			end	
		end 
	end
endmodule