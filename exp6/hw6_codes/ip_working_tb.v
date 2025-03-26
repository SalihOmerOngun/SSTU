`timescale 1ns / 1ps


module clock_gen_tb();

	reg CLK = 1'b0;
	reg RST = 1'b0;
	wire [6:0] CNT100;
	wire [6:0] CNT80;
	wire [6:0] CNT60;	

	
	clock_gen uut
	(
		.clk(CLK),
		.rst(RST),
		.cnt100(CNT100),
		.cnt80(CNT80),
		.cnt60(CNT60)
	);
	

	
	always begin
        #5 CLK = ~CLK; 
    end
	
	initial begin

        RST = 1;  
        #50;      
        RST = 0;  

        #2000;  
        $finish;
    end
endmodule	
	
	
module clock_gating_tb();

	reg CLK = 1'b0;
	reg RST = 1'b0;
	wire [6:0] CNT50;
	wire [6:0] CNT25;
	
	clock_gating uut
	(
		.clk(CLK),
		.rst(RST),
		.cnt50(CNT50),
		.cnt25(CNT25)
	);
	
	always begin
		#5 CLK = ~CLK; 
    end
	
	initial begin

        RST = 1;  
        #105;      
        RST = 0;  

        #400; 
        RST = 1;  
        #105;      
        RST = 0;
		#500;	
        $finish;
    end
endmodule	

module block_ram_tb();  // delay süreleri çok fazla o yüzden konsoldan takip et // addra ya i atayýnca douta ya iþlemesi için ve dina ya deðer atayýnca douta ya iþlemesi için delau koy

	reg clka = 1'b0;  // block ram douta ve addra anlamak icin hw8'e de bak
	reg wea = 1'b0;
	//reg ena = 1'b1;
	reg [3:0] addra = 4'b0;
	reg [7:0] dina = 8'b0;
	wire [7:0] douta;
	integer i;
	reg [7:0] vary [15:0];
    //reg [7:0] vary;
    //reg [7:0] vary2;
	block_ram uut
	(
		.clka(clka),
		.wea(wea),
		.addra(addra),
		.dina(dina),
		.douta(douta)
	);
	
	always begin
		#5 clka = ~clka; 
    end

	initial begin
		$display("we are reading");
		#300; // ilk baslangýcta LOCKED oluyor
		for(i = 0; i<16; i=i+1) begin
			addra = i;
			#50; // douta için bekle
			$display("Address: %d, Data Read: %h", addra, douta);
		end
		
		#10;
		// wea= 1'b1 iken okuma yapmýyor douta yazdýrmýyor. 
		$display("we are writing to array");
		for(i = 0; i<16; i=i+1) begin
			addra = i;
			#50; // douta için bekle
			vary[15-i] = douta;
			$display("array'e yaz  Address: %d, Data Output: %h,Vary: %h", addra, douta,vary[15-i]);
		end
		
		#10;
		$display("we are writing to address");
		wea = 1'b1;
		for(i = 0; i<16; i=i+1) begin
			addra = i;
			dina = vary[i];
			#50 // doutaya iþlemesi için bekle delay koymazsan adres deðiþiyor dina deðiþiyor ama bir önceki adresin doutasýna koyuyor
			$display("Address: %d, Data Input: %h, Vary: %h, Data Output: %h", addra, dina,vary[i],douta);
		end	
			


		$display("we are reading number backwards");
		wea = 1'b0;
		for(i = 0; i<16; i=i+1) begin
			addra = i;
			#50; // douta için bekle 
			$display("Address: %d, Data Read: %h", addra, douta);
		end
		$finish;
	end	
endmodule	



module FIFO_tb();

	reg clk = 1'b0;
	reg rst = 1'b0;
	reg wr_en = 1'b0;
	reg rd_en = 1'b0;
	reg [7:0] din = 1'b0;
	wire [7:0] dout;
	wire empty;
	wire full;
	wire overflow;
	wire underflow;
	integer i = 0;

	FIFO uut
	(
		.clk(clk),
		.rst(rst),
		.wr_en(wr_en),
		.rd_en(rd_en),
		.din(din),
		.dout(dout),
		.empty(empty),
		.full(full),
		.overflow(overflow),
		.underflow(underflow)
	);


	always begin
		#5 clk = ~clk; 
    end

	initial begin
		#200;
		rst = 1'b1;
        #20;
        rst = 1'b0;
		#350;
		while(i<65) begin
			wr_en = 1'b1;
			din = i;
			$display("Data Write: %d",din);
			rd_en = 1'b1;
			i=i+1;
			#10;
			$display("Data Read: %d",dout);
		end
	end
endmodule	