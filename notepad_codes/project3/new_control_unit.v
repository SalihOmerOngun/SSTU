`timescale 1ns / 1ps

module control_unit
(
	input clk,
	input rst,
	input start,
	input co,
	input z,
	output reg busy,
	output reg [1:0] insel,
	output [7:0] cu_const,
	output reg [2:0] in_mux_add,
	output reg [3:0] out_mux_add,
	output reg [3:0] reg_add,
	output reg we	
);
	localparam IDLE   	   = 5'b00000;
	localparam START  	   = 5'b00001;
	localparam ZERO_A 	   = 5'b00010;
	localparam ZERO_B 	   = 5'b00011;   
	localparam OUT1   	   = 5'b00100;
	localparam OUT1_1 	   = 5'b00101;
	localparam OUT1_2 	   = 5'b00110;	
	localparam EXP_SUB 	   = 5'b00111;
	localparam SUB_REC     = 5'b01000;	
	localparam SEL_BASE    = 5'b01001;
	localparam EXP_TO_BASE = 5'b01010;		
	localparam MULT_SUB    = 5'b01011;
	localparam ADD_REC     = 5'b01100;
	localparam MULT_ADD    = 5'b01101;
	localparam SEL_SUM_A   = 5'b01110;
	localparam ADD_RES     = 5'b01111;
	localparam SEL_A       = 5'b10000;
	localparam DONE        = 5'b10001;
	localparam ARA1        = 5'b10010;	
	localparam ARA2       = 5'b10011;		
	reg [4:0] state;
	
	assign cu_const = 8'b11111111;
	
	always @(posedge clk or posedge rst) begin
	
		if (rst == 1'b1) begin
			state <= IDLE;
			we <= 0;
			
		end
		
		else begin 
			case(state)
				IDLE: begin
					if(start == 1'b1) begin 
						state <= START;
						we <= 1'b1;
						busy <= 1;
						in_mux_add <= 3'd0;
						reg_add <= 4'd4; // A degerini registira atadık hem B = 1 hem de sonraki işlemde ekleme yakmak icin
					end
				end
								
				START: begin
					in_mux_add <= 3'd0; //  A secildi
					reg_add <= 4'd1; // A inA ya verildi
					state <= ARA1;
				end	
				
				ARA1: begin 
					insel <= 2'd3; // shift yapildi // inA ya register dan veri 1 clk sonra gelir eger hemen insel i start a yazarsan eski veriyi alır 
					state <= ZERO_A;
				
				end
				
				ZERO_A: begin // A sıfır mı 
					if( z == 1) begin
						state <= DONE;
					end	
					else begin 
						state <= ARA2;
						in_mux_add <= 3'd1; // B seciyorum  // in mux out hemen alyor veriyi
						reg_add <= 4'd1; // B yi inA veriyorum // inA bundan 1 clk sonra alıyor 

					end
				end	
				
				ARA2: begin 
					insel <= 2'd3; // shift yapildi // inA ya register dan veri 1 clk sonra gelir eger hemen insel i start a yazarsan eski veriyi alır 
					state <= ZERO_B;
				end
			
				ZERO_B: begin 
					if( z == 1) begin
						state <= OUT1;
						in_mux_add <= 3'd2; // cuconst secildi
						reg_add <= 4'd1; // inA ya verildi
					end	
					else begin 
						state <= EXP_SUB; 
						in_mux_add <= 3'd1; // B seciyorum 
						reg_add <= 4'd1; // B yi inA veriyorum 
					end
				end
				
				OUT1: begin 
					state <= OUT1_1;
					in_mux_add <= 3'd2; // cuconst secildi
					reg_add <= 4'd2; // inB ye verildi      // oncesinde de inB de constant vardı sıkıntı olmadı
					//insel <= 2'd2; // 255 + 255 yapilip 510 yani 1_1111_1110 bulundu // insel secince ALU out hemen hesaplandı // reg_add secince inA ve inB ye deger 1 clk sonra gidiyor ama hemen insel degisince ALU veriyi eski inA ve eski inB den alıyor  
					// o yuzden OUT1_1 e koyduk bu işlemin insel'ini
				end				
				
				OUT1_1: begin 
					state <= OUT1_2;
					insel <= 2'd2; // 255 + 255 yapilip 510 yani 1_1111_1110 bulundu // insel secince ALU out hemen hesaplandı // reg_add secince inA ve inB ye deger 1 clk sonra gidiyor ama hemen insel degisince ALU veriyi eski inA ve eski inB den alıyor
					in_mux_add <= 3'd3; // ALUout (1_1111_1110) secildi
					reg_add <= 4'd1; // inA ye verildi
				end	
				

				OUT1_2: begin 
					state <= DONE;
					insel <= 2'd1; // 255 ile 510 exor oldu 0000_0001 yani decimal 1 bulundu  // insel 1_1111_1110 inA dan düzgün alsın diye bir sonraki clk için buraya koydum 
					in_mux_add <= 3'd3; // ALUout (0000_0001) secildi
					reg_add <= 4'd4; // DONE da outa verilen register4 e verildi
				end	
				
				EXP_SUB : begin
					in_mux_add <= 3'd2; // constant sec
					reg_add <= 4'd2; // constant inB ye gonder 
					insel <= 2'd2; // B dan 1 cikar    // insel diger state de olamlıydı arada 1 clk yanlis sonuc uretiyor ama sonuc degismiyor o yuzden deggistirmedim
					state <= SUB_REC;		
				end
				
				SUB_REC : begin
					in_mux_add <= 3'd3; // Eksilen B yi (alu out) SEC
					reg_add <= 4'd3;	// Register a at 
					//if( z == 0 and CO == 0) begin // B == 0 
					//	 // sonuc 1 olmalı ama nasıl 
					//end
					if ( z == 1) begin // ustte ifade kalmadı B = 0 oldu
						state <= DONE; 
						//out_mux_add <= 4'd4; // toplam degeri feedback olarak verildi 
					end
					else begin 
						state <= SEL_BASE;
						out_mux_add <= 4'd4; // toplam degeri feedback olarak verildi ( base olarak kullanilacak) 
					end
					
				end
				
				SEL_BASE: begin // yeniiii
					out_mux_add <= 4'd4; // toplam degeri feedback olarak verildi (base olarak kullanilacak)  // out degerini secip aynı anda inmux ve reg add ile registera atayabilirsin aynı anda oluyor sikinti yok 
					in_mux_add <= 3'd4;	//  base'i sec
					reg_add <= 4'd6; // base i registira atadik
					state <= EXP_TO_BASE;
				end
				
				EXP_TO_BASE : begin
					in_mux_add <= 3'd0; // A sec
					reg_add <= 4'd1; // A yi inA ya gonder 
					state <= MULT_SUB;
				end
				
				MULT_SUB: begin   
					in_mux_add <= 3'd2; // constant sec
					reg_add <= 4'd2; // constan i inB ya gonder 
					insel <= 2'd2; // A dan 1 cikar  // insel diger state de olamlıydı arada 1 clk yanlis sonuc uretiyor ama sonuc degismiyor o yuzden deggistirmedim
					state <= ADD_REC;	

				end
				
				ADD_REC: begin
					in_mux_add <= 3'd3; // Eksilen A yi (alu out) SEC
					reg_add <= 4'd5;	// Register a at 	
					state <= MULT_ADD;	
				end
				

				
				MULT_ADD : begin
					if (z == 1) begin  // toplama bitti 
						state <= EXP_SUB;
						out_mux_add <= 4'd3; // register da tutulan B yi seciyorum
						in_mux_add <= 3'd4; // feedback olan değeri seçtim   
						reg_add <= 4'd1; // inA ya atiyorum
					end
					
					else begin  // yeniiiiiiii
						out_mux_add <= 4'd6; // register da tutulan base degerini sec
						in_mux_add <= 3'd4; // base degerini sec
						reg_add <= 4'd1;   // inA ya ver
						state <= SEL_SUM_A;
					end
				end
				
				
				SEL_SUM_A: begin
					out_mux_add <= 4'd4; // register da tutulan degeri feedback yap  // burada degeri feedback yapiyoruz yani registerdan gecmiyor o yuzden insel ile ayni blokta olabilir
					in_mux_add <= 3'd4; // registerda tutulan degeri sec 
					reg_add <= 4'd2; // degeri inB ye ver
					insel <= 2'd2; // base ile tutulan degeri topla  
					state <= ADD_RES;
				end
				
				ADD_RES : begin
					in_mux_add <= 3'd3; // (toplanan sayiyi yani ALUout sec)
					reg_add <= 4'd4; // toplamı baska registire ata
					state <= SEL_A;
				end
				
				SEL_A: begin
					out_mux_add <= 4'd5; // Eksilen A yi sec
					in_mux_add <= 3'd4; 
					reg_add <= 4'd1; // eksilen A yi inA ya ver
					state <= MULT_SUB;
					
				
				end
				
				DONE: begin
					out_mux_add <= 4'd4; // toplam degeri feedback olarak verildi 
					in_mux_add <= 4'd4; // son deger secildi
					reg_add <= 4'd0;	// cikisa verildi
					busy <= 0;  // we yi sıfır yapınca cikisa deger gitmiyor
					state <= IDLE;	
				end
				
				default: begin

				end		
			endcase
		end 
	end
endmodule 

//module control_unit // eski 
//(
//	input clk,
//	input rst,
//	input start,
//	input co,
//	input z,
//	output reg busy,
//	output reg [1:0] insel,
//	output [7:0] cu_const,
//	output reg [2:0] in_mux_add,
//	output reg [3:0] out_mux_add,
//	output reg [3:0] reg_add,
//	output reg we	
//);
//	localparam IDLE = 4'b0000;
//	localparam START = 4'b0001;
//	localparam ZERO = 4'b0010;
//	localparam EXP_SUB = 4'b0011;   
//	localparam SUB_REC = 4'b0100;
//	localparam EXP_TO_BASE = 4'b0101;
//	localparam MULT_SUB = 4'b0110;	
//	localparam ADD_REC = 4'b0111;
//	localparam MULT_ADD = 4'b1000;	
//	localparam SEL_SUM_A = 4'b1001;
//	localparam ADD_RES = 4'b1010;		
//	localparam SEL_A = 4'b1011;
//	localparam DONE = 4'b1100;
//	localparam SEL_BASE = 4'b1101;
//	reg [3:0] state;
//	
//	assign cu_const = 8'b11111111;
//	
//	always @(posedge clk or posedge rst) begin
//	
//		if (rst == 1'b1) begin
//			state <= IDLE;
//			we <= 0;
//			
//		end
//		
//		else begin 
//			case(state)
//				IDLE: begin
//					if(start == 1'b1) begin 
//						state <= START;
//						we <= 1'b1;
//						busy <= 1;
//						in_mux_add <= 3'd0;
//						reg_add <= 4'd4; // A degerini registira atadık hem B = 1 hem de sonraki işlemde ekleme yakmak icin
//					end
//				end
//								
//				START: begin
//					in_mux_add <= 3'd0; //  A secildi
//					reg_add <= 4'd1; // A inA ya verildi
//					insel <= 2'd3; // shift yapildi
//					state <= ZERO;	
//				end	
//				
//				ZERO: begin // A sıfır mı 
//					if( z == 1) begin
//						state <= DONE;
//					end	
//					else begin 
//						state <= EXP_SUB;
//						in_mux_add <= 3'd1; // B seciyorum 
//						reg_add <= 4'd1; // B yi inA veriyorum 
//					end
//					
//				end	
//				
//				EXP_SUB : begin
//					in_mux_add <= 3'd2; // constant sec
//					reg_add <= 4'd2; // constant inB ye gonder 
//					insel <= 2'd2; // B dan 1 cikar  
//					state <= SUB_REC;		
//				end
//				
//				SUB_REC : begin
//					in_mux_add <= 3'd3; // Eksilen B yi (alu out) SEC
//					reg_add <= 4'd3;	// Register a at 
//					//if( z == 0 and CO == 0) begin // B == 0 
//					//	 // sonuc 1 olmalı ama nasıl 
//					//end
//					if ( z == 1) begin // ustte ifade kalmadı B = 0 oldu
//						state <= DONE; 
//						//out_mux_add <= 4'd4; // toplam degeri feedback olarak verildi 
//					end
//					else begin 
//						state <= SEL_BASE;
//						out_mux_add <= 4'd4; // toplam degeri feedback olarak verildi ( base olarak kullanilacak) 
//					end
//					
//				end
//				
//				SEL_BASE: begin // yeniiii
//					out_mux_add <= 4'd4; // toplam degeri feedback olarak verildi (base olarak kullanilacak)  // out degerini secip aynı anda inmux ve reg add ile registera atayabilirsin aynı anda oluyor sikinti yok 
//					in_mux_add <= 3'd4;	//  base'i sec
//					reg_add <= 4'd6; // base i registira atadik
//					state <= EXP_TO_BASE;
//				end
//				
//				EXP_TO_BASE : begin
//					in_mux_add <= 3'd0; // A sec
//					reg_add <= 4'd1; // A yi inA ya gonder 
//					state <= MULT_SUB;
//				end
//				
//				MULT_SUB: begin   
//					in_mux_add <= 3'd2; // constant sec
//					reg_add <= 4'd2; // constan i inB ya gonder 
//					insel <= 2'd2; // A dan 1 cikar  
//					state <= ADD_REC;	
//
//				end
//				
//				ADD_REC: begin
//					in_mux_add <= 3'd3; // Eksilen A yi (alu out) SEC
//					reg_add <= 4'd5;	// Register a at 	
//					state <= MULT_ADD;	
//				end
//				
//
//				
//				MULT_ADD : begin
//					if (z == 1) begin  // toplama bitti 
//						state <= EXP_SUB;
//						out_mux_add <= 4'd3; // register da tutulan B yi seciyorum
//						in_mux_add <= 3'd4; // feedback olan değeri seçtim   
//						reg_add <= 4'd1; // inA ya atiyorum
//					end
//					
//					else begin  // yeniiiiiiii
//						out_mux_add <= 4'd6; // register da tutulan base degerini sec
//						in_mux_add <= 3'd4; // base degerini sec
//						reg_add <= 4'd1;   // inA ya ver
//						state <= SEL_SUM_A;
//					end
//				end
//				
//				
//				SEL_SUM_A: begin
//					out_mux_add <= 4'd4; // register da tutulan degeri feedback yap 
//					in_mux_add <= 3'd4; // registerda tutulan degeri sec 
//					reg_add <= 4'd2; // degeri inB ye ver
//					insel <= 2'd2; // base ile tutulan degeri topla  
//					state <= ADD_RES;
//				end
//				
//				ADD_RES : begin
//					in_mux_add <= 3'd3; // (toplanan sayiyi yani ALUout sec)
//					reg_add <= 4'd4; // toplamı baska registire ata
//					state <= SEL_A;
//				end
//				
//				SEL_A: begin
//					out_mux_add <= 4'd5; // Eksilen A yi sec
//					in_mux_add <= 3'd4; 
//					reg_add <= 4'd1; // eksilen A yi inA ya ver
//					state <= MULT_SUB;
//					
//				
//				end
//				
//				DONE: begin
//					out_mux_add <= 4'd4; // toplam degeri feedback olarak verildi 
//					in_mux_add <= 4'd4; // son deger secildi
//					reg_add <= 4'd0;	// cikisa verildi
//					busy <= 0;  // we yi sıfır yapınca cikisa deger gitmiyor
//					state <= IDLE;	
//				end
//				
//				default: begin
//
//				end
//				
//			endcase
//		end 
//	end
//
//endmodule 