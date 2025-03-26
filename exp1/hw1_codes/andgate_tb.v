`timescale 1ns / 1ps


module andgate_tb();

	reg L1=0;
	reg L2=0;
	wire O;
	
	andgate uut(
		
		.l1(L1),
		.l2(L2),
		.o(O)
	);	
	
	initial
	begin 
		
		L1=0; L2=0;
		#10;
		L1=0; L2=1;
		#10;
		L1=1; L2=0;
		#10;
		L1=1; L2=1;
		#10;		
	end

endmodule	