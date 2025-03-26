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
	localparam IDLE = 4'b0000;
	localparam START = 4'b0001;
	localparam ZERO = 4'b0010;
	localparam EXP_SUB = 4'b0011;   
	localparam SUB_REC = 4'b0100;
	localparam EXP_TO_BASE = 4'b0101;
	localparam MULT_SUB = 4'b0110;	
	localparam ADD_REC = 4'b0111;
	localparam MULT_ADD = 4'b1000;	
	localparam SEL_SUM_A = 4'b1001;
	localparam ADD_RES = 4'b1010;		
	localparam SEL_A = 4'b1011;
	localparam DONE = 4'b1100;
	localparam SEL_BASE = 4'b1101;
	reg [3:0] state;
	
	assign cu_const = 8'b11111111;
	
	
	always @(posedge clk or posedge rst) begin
	
		if (rst == 1'b1) begin
			state <= IDLE;
			out_mux_add <= 4'd4;
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
					insel <= 2'd3; // shift yapildi
					state <= ZERO;	
				end	
				
				ZERO: begin // A sıfır mı 
					if( z == 1) begin
						state <= DONE;
						out_mux_add <= 4'd4; // A degeri feedback olarak verildi 
					end	
					else begin 
						state <= EXP_SUB;
						in_mux_add <= 3'd1; // B seciyorum 
						reg_add <= 4'd1; // B yi inA veriyorum 
					end
					
				end	
				
				EXP_SUB : begin
					in_mux_add <= 3'd2; // constant sec
					reg_add <= 4'd2; // constant inB ye gonder 
					insel <= 2'd2; // B dan 1 cikar  
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
						out_mux_add <= 4'd4; // toplam degeri feedback olarak verildi 
					end
					else begin 
						state <= SEL_BASE;
						out_mux_add <= 4'd4; // toplam degeri feedback olarak verildi ( base olarak kullanilacak) 
					end
					
				end
				
				SEL_BASE: begin // yeniiii
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
					insel <= 2'd2; // A dan 1 cikar  
					state <= ADD_REC;	

				end
				
				ADD_REC: begin
					in_mux_add <= 3'd3; // Eksilen A yi (alu out) SEC
					reg_add <= 4'd5;	// Register a at 	
					out_mux_add <= 4'd6; // register da tutulan base degerini sec
					state <= MULT_ADD;	
				end
				

				
				MULT_ADD : begin
					if (z == 1) begin  // toplama bitti 
						state <= EXP_SUB;
						out_mux_add <= 4'd3; // register da tutulan B yi seciyorum
						in_mux_add <= 3'd4; // feedback olan değeri seçtim   // in mux ta secmemisim öncesinde
						reg_add <= 4'd1; // inA ya atiyorum
					end
					
					else begin  // yeniiiiiiii
						in_mux_add <= 3'd4; // base degerini sec
						reg_add <= 4'd1;   // inA ya ver
						state <= SEL_SUM_A;
					end
				end
				
				
				SEL_SUM_A: begin
					out_mux_add <= 4'd4; // register da tutulan degeri feedback yap // out_mux_nerede olmalı bilemiyorum suan eger aynı yerde olmazsa mult add else de ver 
					in_mux_add <= 3'd4; // registerda tutulan degeri sec 
					reg_add <= 4'd2; // degeri inB ye ver
					insel <= 2'd2; // base ile tutulan degeri topla  
					state <= ADD_RES;
				end
				
				ADD_RES : begin
					in_mux_add <= 3'd3; // ( toplanan sayiyi yani ALUout sec)
					reg_add <= 4'd4; // toplamı baska registire ata
					out_mux_add <= 4'd5; // Eksilen A yi sec
					state <= SEL_A;
				end
				
				SEL_A: begin
					in_mux_add <= 3'd4; 
					reg_add <= 4'd1; // eksilen A yi inA ya ver
					state <= MULT_SUB;
					
				
				end
				
				DONE: begin
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



//module control_unit
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
//	
//	reg [3:0] state;
//	
//	assign cu_const = 8'b11111111;
//	
//	
//	always @(posedge clk or posedge rst) begin
//	
//		if (rst == 1'b1) begin
//			state <= IDLE;
//			out_mux_add <= 4'd4;
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
//						out_mux_add <= 4'd4; // A degeri feedback olarak verildi 
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
//						out_mux_add <= 4'd4; // A degeri feedback olarak verildi 
//					end
//					else begin 
//						state <= EXP_TO_BASE;
//					end
//					
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
//					out_mux_add <= 4'd4; // register da tutulan toplam degerini sec
//					state <= MULT_ADD;	
//				end
//				
//
//				
//				MULT_ADD : begin
//					if (z == 1) begin  // toplama bitti 
//						state <= EXP_SUB;
//						out_mux_add <= 4'd3; // register da tutulan B yi seciyorum
//						in_mux_add <= 3'd4; // feedback olan değeri seçtim   // in mux ta secmemisim öncesinde
//						reg_add <= 4'd1; // inA ya atiyorum
//					end
//					
//					else begin 
//						in_mux_add <= 3'd0; // input A yi sec
//						reg_add <= 4'd1;   // input A yi inA ya ver
//						state <= SEL_SUM_A;
//					end
//				end
//				
//				
//				SEL_SUM_A: begin
//					out_mux_add <= 4'd4; // register da tutulan degeri feedback yap
//					in_mux_add <= 3'd4; // registerda tutulan degeri sec 
//					reg_add <= 4'd2; // degeri inB ye ver
//					insel <= 2'd2; // input A ile A yi topla 
//					state <= ADD_RES;
//				end
//				
//				ADD_RES : begin
//					in_mux_add <= 3'd3; // ( toplanan sayiyi yani ALUout sec)
//					reg_add <= 4'd4; // A ile A nin toplamını baska registire ata
//					out_mux_add <= 4'd5; // Eksilen A yi sec
//					state <= SEL_A;
//				end
//				
//				SEL_A: begin
//					in_mux_add <= 3'd4; 
//					reg_add <= 4'd1; // eksilen A yi inA ya ver
//					state <= MULT_SUB;
//					
//				
//				end
//				
//				DONE: begin
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