`timescale 1ns / 1ps




module calc_hamming_tb();

	reg [31:0] DATA = 32'b0;
	wire [5:0] RESULT;
	integer file, out_file,ones_count;
	
	calc_hamming uut
	(
		.DATA(DATA),
		.RESULT(RESULT)
	);
	

	initial begin

		file = $fopen("stimulus_file.txt", "r");
		if (file == 0) begin
			$display("Cannot open stimulus file.");
			$finish;
		end

        out_file = $fopen("outputs.txt", "w");
        if (out_file == 0) begin
            $display("Cannot open outputs file.");
            $finish;
        end


		while (!$feof(file)) begin
            $fscanf(file, "%b %d\n", DATA, ones_count);
			#10;
			if( ones_count == RESULT) begin
				$display("DATA: %b, Ones Count:%d ,RESULT: %d, TRUE",DATA, ones_count,RESULT);
				$fdisplay(out_file, "DATA: %b, Ones Count: %d, RESULT: %d, TRUE", DATA, ones_count, RESULT);
			end	
			else begin
				$display("DATA: %b, Ones Count:%d ,RESULT: %d, FALSE",DATA, ones_count,RESULT);
				$fdisplay(out_file, "DATA: %b, Ones Count: %d, RESULT: %d, TRUE", DATA, ones_count, RESULT);
			end	
		end
		$fclose(file);
		$fclose(out_file);
		$finish;
	end

endmodule		
	

module slice_adder_tb();

	reg [3:0] SLICE = 4'b000;
	wire [2:0] SUM;
	
	slice_adder uut
	(
		.slice(SLICE),
		.sum(SUM)
	);

	initial
	begin
		
		SLICE = 4'b0000;
		#10;
		SLICE = 4'b0001;
		#10;	
		SLICE = 4'b0010;
		#10;
		SLICE = 4'b0011;
		#10;
		SLICE = 4'b0100;
		#10;
		SLICE = 4'b0101;
		#10;
		SLICE = 4'b0110;
		#10;	
		SLICE = 4'b0111;
		#10;	
		SLICE = 4'b1000;
		#10;	
		SLICE = 4'b1001;
		#10;	
		SLICE = 4'b1010;
		#10;	
		SLICE = 4'b1011;
		#10;	
		SLICE = 4'b1100;
		#10;	
		SLICE = 4'b1101;
		#10;	
		SLICE = 4'b1110;
		#10;		
		SLICE = 4'b1111;
		#10;	
		$finish;
	end
endmodule	