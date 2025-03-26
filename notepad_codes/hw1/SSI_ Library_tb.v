`timescale 1ns / 1ps

module Top_Module_tb();

	reg [15:0]IN=16'b0;
	wire [7:0]OUT;
	//integer i;
	//integer y;
	Top_Module uut(
	
		.IN(IN),
		.OUT(OUT)
	);	
	
	initial 
	begin

		IN[0]=0; IN[1]=0; //AND
		#10;
		IN[0]=1; IN[1]=0;
		#10;
		IN[0]=0; IN[1]=1;
		#10;
		IN[0]=1; IN[1]=1;
		#10;
		
		IN[2]=0; IN[3]=0; // OR
		#10;
		IN[2]=1; IN[3]=0;
		#10;
		IN[2]=0; IN[3]=1;
		#10;
		IN[2]=1; IN[3]=1;
		#10;
		
		IN[4]=0; //NOT
		#10;
		IN[4]=1; 
		#10;
		
		IN[5]=0; IN[6]=0; // NAND
		#10;
		IN[5]=1; IN[6]=0;
		#10;
		IN[5]=0; IN[6]=1;
		#10;
		IN[5]=1; IN[6]=1;
		#10;

		IN[7]=0; IN[8]=0; // NOR
		#10;
		IN[7]=1; IN[8]=0;
		#10;
		IN[7]=0; IN[8]=1;
		#10;
		IN[7]=1; IN[8]=1;
		#10;
		
		IN[9]=0; IN[10]=0; //EXOR 
		#10;
		IN[9]=1; IN[10]=0;
		#10;
		IN[9]=0; IN[10]=1;
		#10;
		IN[9]=1; IN[10]=1;
		#10;
		
		IN[11]=0; IN[12]=0; //EXNOR
		#10;
		IN[11]=1; IN[12]=0;
		#10;
		IN[11]=0; IN[12]=1;
		#10;
		IN[11]=1; IN[12]=1;
		#10;
		
		IN[13]=0; IN[14]=0; //TRI
		#10;
		IN[13]=1; IN[14]=0;
		#10;
		IN[13]=0; IN[14]=1;
		#10;
		IN[13]=1; IN[14]=1;
		#10;
		
	end
endmodule		

	/*
		for (i=0; i<14; i=i+2) begin
			for (y=0; y<5; y=y+1) begin
				if (y==0) begin
					IN[i]=0; IN[i+1]=0;
					#10;
				end
				else if (y==1) begin
					IN[i]=0; IN[i+1]=1;
					#10;
				end 
				else if (y==2) begin
					IN[i]=1; IN[i+1]=0;
					#10;
				end 
				else if (y==3) begin
					IN[i]=1; IN[i+1]=1;
					#10;
				end 
			end
			IN[i]=0; IN[i+1]=0;
		end
	*/