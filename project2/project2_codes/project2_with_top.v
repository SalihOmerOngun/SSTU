`timescale 1ns / 1ps


module uart_rx #(parameter [16:0]  freq= 115200)
(
	input clk,
	input rst,
	input d_in,
	input rx_en,
	output reg baud_en,
	input count_8x_ready,
	input count_baud_ready,
	output [7:0] d_out,
	output reg start,
	output reg busy,
	output done
);
	reg [3:0] count_ones;
	reg [3:0] count_zeros;
	reg [2:0] counter_halfperiod;
	reg done_reg;
	reg [7:0] d_out_reg;
	reg [3:0] bit_in; 
	localparam IDLE = 2'b00;
	localparam START = 2'b01;
	localparam DATA = 2'b10;
	localparam STOP = 2'b11;
	reg [1:0] state;


	always @(posedge clk) begin

		if (rst == 1'b1) begin
			state <= IDLE;
			done_reg <= 0;
			baud_en <= 0;
			start <= 0;
			busy <= 0;			
			counter_halfperiod <= 2'b0;
			count_ones <= 0;
			count_zeros <= 0;
		end
		else begin 
			case(state)
				IDLE: begin
					done_reg <= 0;
					baud_en <= 0;
					if (rx_en == 1) begin
						state <= START;
						bit_in <= 0;
						start <=1;
					end
				end
				
				START: begin
					if(d_in == 0) begin
						baud_en <= 1;
						if(counter_halfperiod < 4) begin // [1:0] yapınca 3 oluyor bu conditiona giriyor counter 1 artıyor ve4 oluyor. Biz 2 bit oluşturduğumuz için 4 olunca yine sıfır gözüküyor çünkü 4=100 biz 2 bit yapınca sıfır goruyoruz. buyuk kucuk kullanirken dikkatli ol  
							if(count_8x_ready == 1) begin
								counter_halfperiod = counter_halfperiod + 1;
							end
						end
						else begin 
							state <= DATA;
							busy <=1;
							start <= 0;
							counter_halfperiod = 2'b0;
							baud_en <= 0; 	
						end
					end	
				end	
				
				DATA: begin 
					baud_en <= 1;
					if(count_baud_ready == 1) begin
						if(count_ones > count_zeros) begin
							d_out_reg = {1'b1,d_out_reg[7:1]}; //{1,d_out_reg[7:1]} dersen hata veriyor 
						end 
						if(count_ones < count_zeros) begin
							d_out_reg = {1'b0,d_out_reg[7:1]};
						end		
						if(bit_in == 7) begin
							state <= STOP;
							busy <= 0;
							bit_in <= 0;
						end 
						else begin
							bit_in <= bit_in + 1; 
						end
						count_ones = 3'b0;
						count_zeros = 3'b0;
					end
					
					else begin
						if(count_8x_ready == 1) begin  	
							if(d_in == 1) begin
								count_ones = count_ones + 1;
							end
							
							else begin 
								count_zeros = count_zeros + 1;
							end
						end 		
					end	
				end	
				
				STOP: begin
					if(count_baud_ready == 1) begin
						state <= IDLE;
						baud_en <= 0;
						done_reg <= 1;
					end
				end
				
				default: begin
					state <= IDLE;
					done_reg <= 0;  
					d_out_reg <= 1;
					baud_en <= 0;
				end
				
			endcase
		end 
	end
	assign done = done_reg;
	assign d_out = d_out_reg;
endmodule





module uart_tx #(parameter [16:0]  freq= 115200)
(
	input clk,
	input rst,
	input [7:0] d_in,
	input tx_en,
	input count_baud_ready,
	output reg baud_en,
	output reg start,
	output reg busy,
	output seri_out,
	output done
);

	reg done_reg, seri_out_reg;
	reg [2:0] bit_in; 
	reg [7:0] buffer;
	localparam IDLE = 2'b00;
	localparam START = 2'b01;
	localparam DATA = 2'b10;
	localparam STOP = 2'b11;
	reg [1:0] state;
	
	always @(posedge clk) begin
	
		if (rst == 1'b1) begin
			state <= IDLE;
			done_reg <= 0;
			start <= 0;
			busy <= 0;			
			seri_out_reg <= 1;
			baud_en <= 0;
		end
		else begin 
			case(state)
				IDLE: begin
					done_reg <= 0;
					seri_out_reg <= 1;
					baud_en <= 0;
					buffer <= d_in;
					if (tx_en == 1) begin
						state <= START;
						bit_in <= 0;
					end
				end
				
				START: begin
					seri_out_reg <= 0;
					start <= 1;					
					baud_en <= 1;
					if(count_baud_ready == 1) begin
						state <= DATA;
					end
				end	
				
				DATA: begin 
					start <= 0;
					busy <=1;				
					seri_out_reg <= buffer[0];  // D ,C ,B ,A
					if(count_baud_ready == 1) begin  // 0 ,1 ,2, 3 	
						if(bit_in == 7) begin
							state <= STOP;
							bit_in <= 0;
						end 	
						else begin
							buffer[6:0] <= buffer[7:1]; // A B C , A B, A    
							bit_in <= bit_in + 1; // 1 ,2, 3     // count_baud_ready 1 olduktan 1 clock cycle sonra bit_in değişir. Always bloğunun end'inde değişiyor. O da diğer clock'a denk gelir.
						end
					end 		
				end	
				
				STOP: begin
					seri_out_reg <= 1;
					if(count_baud_ready ==1) begin
						state <= IDLE;
						baud_en <= 0;
						done_reg <= 1;
						busy <=0;						
					end
				end
				
				default: begin
					state <= IDLE;
					done_reg <= 0;  
					seri_out_reg <= 1;
					baud_en <= 0;
				end
				
			endcase
		end 
	end
	assign done = done_reg;
	assign seri_out = seri_out_reg;
endmodule 

module baud_gen #(parameter [16:0]  freq= 115200)  // counter  count ( output sadece count)
(
	input clk,
	input rst,
	input baud_en,
	output count_8x_ready,
	output count_baud_ready
);

	localparam integer clk_freq = 100000000; // Internal clock frequency (100 MHz)
	reg count_8x_ready_reg,count_baud_ready_reg;
	reg [13:0] counter_8x;
	reg [2:0] counter_baud;
	
	always @(posedge clk) begin
		if(rst==1'b1) begin
			counter_baud <= 3'b0; // baud counter
			count_baud_ready_reg <= 0; // baud counter result
			counter_8x <= 13'b0; // 8x counter
			count_8x_ready_reg <= 0; // 8x counter result 
		end
		else if (baud_en == 1) begin
			if(counter_8x ==((clk_freq/(freq*8))-1)) begin // -1 sil
				counter_8x <= 13'b0;
				count_8x_ready_reg <= 1;
				if(counter_baud == 7) begin
					counter_baud <= 3'b0;
					count_baud_ready_reg <= 1;
				end
				else begin 
					counter_baud <= counter_baud + 1;
					count_baud_ready_reg <= 0;
				end
			end
			else begin 
				counter_8x <= counter_8x + 1;
				count_8x_ready_reg <= 0;
				count_baud_ready_reg <= 0;
			end
		end	
		else begin
			count_8x_ready_reg <= 0;
			counter_8x <= 13'b0;
			counter_baud <= 13'b0;
			count_baud_ready_reg <= 0;
		end 	
	end
	assign count_8x_ready = count_8x_ready_reg;
	assign count_baud_ready = count_baud_ready_reg;
endmodule	



module uart_top #(parameter [16:0] freq = 115200) (
    input clk,
    input rst,
    input [7:0] data_in_tx,    // Verici için veri girişi
    input tx_en,            // Verici etkinleştirme
    input rx_en,            // Alıcı etkinleştirme
    output [7:0] data_out_rx,  // Alıcıdan çıkan veri
    output tx_done,         // Verici işlemi tamamlandı sinyali
    output rx_done,         // Alıcı işlemi tamamlandı sinyali
    output tx_start,         // Verici işlemi tamamlandı sinyali
    output rx_start,         // Alıcı işlemi tamamlandı sinyali
    output tx_busy,         // Verici işlemi tamamlandı sinyali
    output rx_busy,         // Alıcı işlemi tamamlandı sinyali	
    output tx_out           // Seri çıkış (tx veri)
);

    wire tx_baud_en,tx_count_baud_ready;
	wire rx_baud_en,rx_count_baud_ready,rx_count_8x_ready;


    // RX için baud gen modülü
    baud_gen #(.freq(freq)) rx_baud_gen (
        .clk(clk),
        .rst(rst),
        .baud_en(rx_baud_en),  // RX etkinleştirme sinyali
        .count_8x_ready(rx_count_8x_ready), 
        .count_baud_ready(rx_count_baud_ready) // RX için baud rate hazır sinyali
    );

    // TX için baud gen modülü
    baud_gen #(.freq(freq)) tx_baud_gen (
        .clk(clk),
        .rst(rst),
        .baud_en(tx_baud_en),  // TX etkinleştirme sinyali
        .count_8x_ready(), 
        .count_baud_ready(tx_count_baud_ready) // TX için baud rate hazır sinyali
    );

    // UART alıcı modülü (RX)
    uart_rx #(.freq(freq)) rx_inst (
        .clk(clk),
        .rst(rst),
        .d_in(tx_out),      // Verici çıkışı, alıcıya veri aktarımı
        .rx_en(rx_en),      // Alıcı etkinleştirme
		.baud_en(rx_baud_en),
		.count_8x_ready(rx_count_8x_ready),
		.start(rx_start),
		.busy(rx_busy),
		.count_baud_ready(rx_count_baud_ready),
        .d_out(data_out_rx),    // Alıcıdan çıkan veri
        .done(rx_done) // Alıcı işlem tamamlandı sinyali
    );

    // UART verici modülü (TX)
    uart_tx #(.freq(freq)) tx_inst (
        .clk(clk),
        .rst(rst),
        .d_in(data_in_tx),     // Alıcıdan alınan veri
        .tx_en(tx_en),       // Verici etkinleştirme
		.count_baud_ready(tx_count_baud_ready),
		.start(tx_start),
		.busy(tx_busy),		
		.baud_en(tx_baud_en),
        .seri_out(tx_out),   // Seri çıkış
        .done(tx_done)       // Verici işlem tamamlandı sinyali
    );
	
endmodule

