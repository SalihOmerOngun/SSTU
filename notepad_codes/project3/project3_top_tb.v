`timescale 1ns / 1ps


module top_module_tb;

    // Testbench sinyalleri
    reg clk;
    reg rst;
    reg start;
    reg [7:0] inA;
    reg [7:0] inB;
    wire busy;
    wire [7:0] out;

    // Test edilen modülün örneklenmesi
    top_module uut (
        .clk(clk),
        .rst(rst),
        .inA(inA),
        .inB(inB),
        .start(start),
        .busy(busy),
        .out(out)
    );

    // Clock üretimi
    always #5 clk = ~clk; // Her 5 zaman biriminde clock terslenir (10 birimlik periyot)

    // Test senaryoları
    initial begin

        clk = 0;
        rst = 1;    // Reset aktif
        start = 0;

        // Reset işleminden çık
        #10 rst = 0;

		#10;
		inA = 8'd0;   
		inB = 8'd1;   
		start = 1;    
		#10 start = 0;
		wait(busy == 0); // İşlem bitene kadar bekle
        #20 
        $display("A=%d, B=%d, Out=%d", inA, inB, out);
	
		#10;
		inA = 8'd0;   
		inB = 8'd2;   
		start = 1;    
		#10 start = 0;
		wait(busy == 0); // İşlem bitene kadar bekle
        #20 
        $display("A=%d, B=%d, Out=%d", inA, inB, out);
		
		#10;
		inA = 8'd0;   
		inB = 8'd3;   
		start = 1;    
		#10 start = 0;
		wait(busy == 0); // İşlem bitene kadar bekle
        #20 
        $display("A=%d, B=%d, Out=%d", inA, inB, out);
		
		#10;
		inA = 8'd1;   
		inB = 8'd0;   
		start = 1;    
		#10 start = 0;
		wait(busy == 0); // İşlem bitene kadar bekle
        #20 
        $display("A=%d, B=%d, Out=%d", inA, inB, out);
	
		#10;
		inA = 8'd1;   
		inB = 8'd1;   
		start = 1;    
		#10 start = 0;
		wait(busy == 0); // İşlem bitene kadar bekle
        #20 
        $display("A=%d, B=%d, Out=%d", inA, inB, out);
		
		#10;
		inA = 8'd1;   
		inB = 8'd2;   
		start = 1;    
		#10 start = 0;
		wait(busy == 0); // İşlem bitene kadar bekle
        #20 
        $display("A=%d, B=%d, Out=%d", inA, inB, out);
	
		#10;
		inA = 8'd1;   
		inB = 8'd3;   
		start = 1;    
		#10 start = 0;
		wait(busy == 0); // İşlem bitene kadar bekle
        #20 
        $display("A=%d, B=%d, Out=%d", inA, inB, out);
	
		#10;
		inA = 8'd2;   
		inB = 8'd0;   
		start = 1;    
		#10 start = 0;
		wait(busy == 0); // İşlem bitene kadar bekle
        #20 
        $display("A=%d, B=%d, Out=%d", inA, inB, out);
	
		#10;
		inA = 8'd2;   
		inB = 8'd1;   
		start = 1;    
		#10 start = 0;
		wait(busy == 0); // İşlem bitene kadar bekle
        #20 
        $display("A=%d, B=%d, Out=%d", inA, inB, out);
		
		#10;
		inA = 8'd2;   
		inB = 8'd2;   
		start = 1;    
		#10 start = 0;
		wait(busy == 0); // İşlem bitene kadar bekle
        #20 
        $display("A=%d, B=%d, Out=%d", inA, inB, out);
		
		#10;
		inA = 8'd2;   
		inB = 8'd3;   
		start = 1;    
		#10 start = 0;
		wait(busy == 0); // İşlem bitene kadar bekle
        #20 
        $display("A=%d, B=%d, Out=%d", inA, inB, out);
		
		#10;
		inA = 8'd3;   
		inB = 8'd0;   
		start = 1;    
		#10 start = 0;
		wait(busy == 0); // İşlem bitene kadar bekle
        #20 
        $display("A=%d, B=%d, Out=%d", inA, inB, out);
		
		#10;
		inA = 8'd3;   
		inB = 8'd1;   
		start = 1;    
		#10 start = 0;
		wait(busy == 0); // İşlem bitene kadar bekle
        #20 
        $display("A=%d, B=%d, Out=%d", inA, inB, out);
		
		#10;
		inA = 8'd3;   
		inB = 8'd2;   
		start = 1;    
		#10 start = 0;
		wait(busy == 0); // İşlem bitene kadar bekle
        #20 
        $display("A=%d, B=%d, Out=%d", inA, inB, out);
		
		#10;
		inA = 8'd3;   
		inB = 8'd3;   
		start = 1;    
		#10 start = 0;
		wait(busy == 0); // İşlem bitene kadar bekle
        #20 
        $display("A=%d, B=%d, Out=%d", inA, inB, out);
        
        #10;
        inA = 8'd7; 
        inB = 8'd2; 
        start = 1;        
        #10 start = 0;     
        wait(busy == 0);   
        #20 
        $display( "A=%d, B=%d, Out=%d", inA, inB, out);	

        #10;
        inA = 8'd3; 
        inB = 8'd5;
        start = 1;         
        #10 start = 0;     
        wait(busy == 0);   
        #20 
        $display(" A=%d, B=%d, Out=%d", inA, inB, out);		
		

        #10;
        inA = 8'd6; 
        inB = 8'd3; 
        start = 1;         
        #10 start = 0;     
        wait(busy == 0);   
        #20 
        $display( "A=%d, B=%d, Out=%d", inA, inB, out);			
		
        #10;
        inA = 8'd5; 
        inB = 8'd3; 
        start = 1;         
        #10 start = 0;     
        wait(busy == 0);   
        #20 
        $display("A=%d, B=%d, Out=%d", inA, inB, out);			
		// Testlerin sonu
        #10;
        $stop; // Simülasyonu durdur
    end

endmodule
