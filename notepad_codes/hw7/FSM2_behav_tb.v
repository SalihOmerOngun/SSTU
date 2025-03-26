`timescale 1ns / 1ps


module div_behav_tb();

	reg clk = 1'b0;
	reg rst = 1'b1; 
	reg x;
	wire z;
	reg [41:0] test = 42'b010011000111000011110000011111000000111111;
	integer i= 41;
	div_behav uut
	(
		.clk(clk),
		.rst(rst),
		.x(x),
		.z(z)
	);
	
	
	always begin
		#5 clk = ~clk; 
    end

	initial begin
	    #10;// x'in input degisimi clock'ın nededge'sinde olursa x_cs açısından daha iyi olur. x karar vermemiz acısından onemli değil, a onenmli
		// o yuzden a clock da deger degistirse yeterli olur.
	    rst = 1'b0;   
		for(i = 41; i>=0; i = i-1) begin
			x = test[i];
			#10;
		end		
		$finish;
	end

endmodule	
