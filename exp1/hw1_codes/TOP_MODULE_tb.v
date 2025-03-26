`timescale 1ns / 1ps

module Top_Module_tb();

	reg [15:0]IN=16'b0;
	wire [7:0]OUT;
	
	Top_Module uut(
	
		.IN(IN),
		.OUT(OUT)
	);	
	
	initial
	begin 
		
		IN[0]=0; IN[1]=0;
		#10;
		IN[0]=0; IN[1]=1;
		#10;
		IN[0]=1; IN[1]=0;
		#10;
		IN[0]=1; IN[1]=1;
		#10;		
	end

endmodule	