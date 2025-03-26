`timescale 1ns / 1ps

module DFF_sync_tb();

    reg CLK= 1'b0;       
    reg RST= 1'b0;        
    reg D= 1'b0;          
    wire Q;         

    // DFF_sync modülünü örnekle
    DFF_sync uut (
        .clk(CLK),
        .rst(RST),
        .D(D),
        .Q(Q)
    );

    // Saat sinyali üretimi
    always begin
        #5 CLK = ~CLK; // Her 5 zaman birimi ile saat sinyalini tersle
    end

    // Test prosedürü
    initial 
	begin
        RST = 1;  // Reset aktif
        #10;
        RST = 0;  // Reset pasif
        #10;
        D = 1;    // D girişine 1 ver
        #10;
        D = 0;    // D girişine 0 ver
        #10;
        RST = 1;  // Reset aktif
        #10;
        D = 1;    // D girişine 1 ver
        #10;
        D = 0;    // D girişine 0 ver
        #10;
        $finish;
    end



endmodule
	
	
module DFF_async_tb();

    reg CLK= 1'b0;       
    reg RST= 1'b0;        
    reg D= 1'b0;          
    wire Q;         

    DFF_async uut (
        .clk(CLK),
        .rst(RST),
        .D(D),
        .Q(Q)
    );

    always begin
        #5 CLK = ~CLK; 
    end

    initial 
	begin
        RST = 1; 
        #10;
        RST = 0;  
        #10;
        D = 1;    
        #10;
        D = 0;    
        #10;
        RST = 1;  
        #10;
        D = 1;   
        #10;
        D = 0;    
        #10;
        $finish;
    end
endmodule	

module shift8_tb();

    reg CLK=1'b0;       
    reg RST=1'b0;        
    reg D=1'b0;          
    wire [7:0] Q;   


    shift8 uut (
        .clk(CLK),
        .rst(RST),
        .D(D),
        .Q(Q)
    );


    always begin
        #5 CLK = ~CLK;  
    end

  
    initial 
	begin
        RST = 1;      
        #10 RST = 0;  

        D = 1;     
        #10;        
        
        D = 0;     
        #10;          
        
        D = 0;        
        #10;          
        
        D = 1;        
        #10;          

        RST = 1;     

        D = 1;       
        #10;         
        
        D = 0;       
        #10;          
        $finish;
    end
endmodule


module clk_divider_tb();

	parameter [27:0] CLK_DIV = 100; //clk_out = 1MHz
	reg CLK_IN=1'b0;
	reg RST=1'b0;
	wire CLK_OUT;
	
	clk_divider #(.CLK_DIV(CLK_DIV)) uut
	(
		.clk_in(CLK_IN),
		.rst(RST),
		.clk_out(CLK_OUT)
	);	
	
	always begin
    #5 CLK_IN = ~CLK_IN;  
	end

    initial begin

        RST = 1;  
        #10;      
        RST = 0;  

        #2000;  
        $finish;
    end
endmodule	



module sliding_leds_tb();

	parameter [23:0] CLK_DIV = 10000000;
	reg CLK = 1'b0;
	reg RST=1'b1;
	reg [1:0] SW = 2'b00;
	wire [15:0] LED;
	
	sliding_leds #(.CLK_DIV(CLK_DIV)) uut
	(
		.clk(CLK),
		.rst(RST),
		.SW(SW),
		.LED(LED)
	);	
	
	always begin
		#5 CLK = ~CLK;  // 100MHz
	end
	
	initial
	begin
		RST = 1;  
        #10;      
        RST = 0;  
		#10;
		
		SW = 2'b01;
		#400000000;
		SW = 2'b10;
        #100000000;
        SW = 2'b11;
        #100000000;
		$finish;
	end
endmodule	