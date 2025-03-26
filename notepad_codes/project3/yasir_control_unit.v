`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.01.2025 01:48:30
// Design Name: 
// Module Name: control_unit
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module control_unit
(
	input clk,
	input reset,
	input Start,
	input CO,
	input Z,
	output reg Busy,
	output reg [1:0] InsSel,
	output [7:0] CUconst,
	output reg [2:0] InMuxAdd,
	output reg [3:0] OutMuxAdd,
	output reg [3:0] RegAdd,
	output reg we	
);

    reg state;
    assign CUconst = 8'b11111111;
    
    localparam IDLE_A = 0;
    localparam IDLE_B = 1;
    localparam START_B = 2;
    localparam SUB_B = 3;
    localparam CONTROLB_Z = 4;
    localparam START_A = 5;
    localparam SUB_A = 6;
    localparam CONTROLA_Z = 7;
    localparam ADD1 = 8;
    localparam ADD2 = 9;
    localparam ADD_REG = 10;
    localparam DONE = 11;
    
    
    always @(posedge clk or posedge reset) begin
            if (reset == 1'b1) begin
			     state <= IDLE_A;
			     OutMuxAdd <= 4'd4; 			
		    end else begin
		          case (state)
		              IDLE_A:begin
		                  if(Start == 1'b1) begin 
						      state <= IDLE_B;
						      we <= 1'b1;
						      Busy <= 1;
						      InMuxAdd <= 3'd0;
						      RegAdd <= 4'd3; // A degerini registira atadýk hem B = 1 hem de sonraki iþlemde ekleme yakmak icin
					       end
					   end
					   IDLE_B:begin
					       InMuxAdd <= 3'd1;
						   RegAdd <= 4'd4; // B deðeri register 4e
						   OutMuxAdd <= 4'd4; // regouta
						   state <= START_B;
					   end
					   START_B:begin
					       InMuxAdd <= 4;
					       RegAdd <= 1;
					       state <= SUB_B;
					   end
					   SUB_B:begin
					       InMuxAdd <= 2;
					       RegAdd <= 2;
					       InsSel <= 2;
					       state <= CONTROLB_Z;
					   end
					   CONTROLB_Z:begin
					       if (Z==0) begin
					           InMuxAdd <= 3;
					           RegAdd <= 4; // B sayaç be deðeri register 4 e
					           OutMuxAdd <= 5; // register 5 sayaç A deðerini tutacak A iþlemine geçerken reoguta gönderiyoruz
					           state <= START_A;
					       end else begin
					           state <= DONE;
					           OutMuxAdd <= 3;
					       end
					  end
					  START_A:begin
					       InMuxAdd <= 4; //regoutta register5 A sayacý var
					       RegAdd <= 1;
					       state <= SUB_A;
					  end
					  SUB_A:begin
					       InMuxAdd <= 2;
					       RegAdd <= 2;
					       InsSel <= 2;
					       state <= CONTROLA_Z; // iþlem yapýldý çýkan A deðeri ALUouta gönderildi
					  end
					  CONTROLA_Z:begin
					       if(Z==0) begin
					            InMuxAdd <= 3;
					            RegAdd <= 5;  //  A sayaç deðeri reg5  e 
					            OutMuxAdd <= 3; //register 3 bizim toplam deðerimizi tutuyor
					            state <= ADD1;
					       end else begin
					          InMuxAdd <= 0; 
					          RegAdd <= 5; //A sayaç deðerini güncelliyoruz
					          state <= START_B;
					          OutMuxAdd <= 4; //register4 teki B sayaç deðerini regouta yolluyoruz					           
					       end
					  end
					  ADD1:begin
					       InMuxAdd <= 4;
					       RegAdd <= 1;
					       state <= ADD2;
					 end
					 ADD2:begin
					      InMuxAdd <= 4;
					      RegAdd <= 2; 
					      InsSel <= 2;
					      state <= ADD_REG;
					end
					ADD_REG:begin 
					     InMuxAdd <= 3;
					     RegAdd <= 3; //yeni toplam deðerimizi register3 koyuyoruz ve tekrar A sayacýna dönüyoruz
					     OutMuxAdd <= 5;    
					     state <= START_A;
					end
					DONE:begin
					     InMuxAdd <= 4;
					     RegAdd <= 0;
					     Busy <= 0;
					end
			 endcase 
		end
	end
		             
		    

endmodule
