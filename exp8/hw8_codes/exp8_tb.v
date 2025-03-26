`timescale 1ns / 1ps

module conv_unit_tb();
    reg pixel_clk = 1'b0;
    reg rst = 1'b0;
    reg enable = 1'b0;
    reg signed [4:0] pixel11, pixel12, pixel13;
    reg signed [4:0] pixel21, pixel22, pixel23;
    reg signed [4:0] pixel31, pixel32, pixel33;
    reg signed [3:0] kernel11, kernel12, kernel13;
    reg signed [3:0] kernel21, kernel22, kernel23;
    reg signed [3:0] kernel31, kernel32, kernel33;
    wire [3:0] pixel_out;

    // Test edilecek modülü bağlama
    conv_unit uut (
        .pixel_clk(pixel_clk),
        .rst(rst),
        .enable(enable),
        .pixel11(pixel11), .pixel12(pixel12), .pixel13(pixel13),
        .pixel21(pixel21), .pixel22(pixel22), .pixel23(pixel23),
        .pixel31(pixel31), .pixel32(pixel32), .pixel33(pixel33),
        .kernel11(kernel11), .kernel12(kernel12), .kernel13(kernel13),
        .kernel21(kernel21), .kernel22(kernel22), .kernel23(kernel23),
        .kernel31(kernel31), .kernel32(kernel32), .kernel33(kernel33),
        .pixel_out(pixel_out)
    );

    // Saat sinyali üretimi
    always begin
        #20 pixel_clk = ~pixel_clk;
    end

    // Test senaryoları
    initial begin
        // Başlangıç durumu
        rst = 1;
        enable = 0;
        pixel11 = 0; pixel12 = 0; pixel13 = 0;
        pixel21 = 0; pixel22 = 0; pixel23 = 0;
        pixel31 = 0; pixel32 = 0; pixel33 = 0;
        kernel11 = 1; kernel12 = 1; kernel13 = 1;
        kernel21 = 1; kernel22 = -8; kernel23 = 1;
        kernel31 = 1; kernel32 = 1; kernel33 = 1;

        #50;
        rst = 0;
        enable = 1;

        // İlk test verisi
        #100;
        pixel11 = 5; pixel12 = 3; pixel13 = 4;
        pixel21 = 7; pixel22 = 6; pixel23 = 2;
        pixel31 = 1; pixel32 = 3; pixel33 = 9;
        kernel11 = 1; kernel12 = 1; kernel13 = 1;
        kernel21 = 1; kernel22 = -8; kernel23 = 1;
        kernel31 = 1; kernel32 = 1; kernel33 = 1;


        // İkinci test verisi
        #200;
        pixel11 = 2; pixel12 = 8; pixel13 = 4;
        pixel21 = 5; pixel22 = 3; pixel23 = 7;
        pixel31 = 9; pixel32 = 0; pixel33 = 6;
        kernel11 = 1; kernel12 = 1; kernel13 = 1;
        kernel21 = 1; kernel22 = -8; kernel23 = 1;
        kernel31 = 1; kernel32 = 1; kernel33 = 1;


        // Üçüncü test verisi
        #200;
        pixel11 = 4; pixel12 = 7; pixel13 = 5;
        pixel21 = 3; pixel22 = 6; pixel23 = 1;
        pixel31 = 8; pixel32 = 2; pixel33 = 0;
        kernel11 = 1; kernel12 = 1; kernel13 = 1;
        kernel21 = 1; kernel22 = -8; kernel23 = 1;
        kernel31 = 1; kernel32 = 1; kernel33 = 1;

        // Reset durumu
        #200;
        rst = 1;
        enable = 0;

        // Simülasyonun sonlandırılması
        #50;
        $finish;
    end
endmodule



module b_ram_red_tb(); 

	reg pixel_clk = 1'b0;
	reg wea = 1'b0;
	reg ena = 1'b0;
	reg [16:0]  addra = 16'b0;
	reg [11:0] dina  = 12'b0;
	wire [11:0] douta;
	integer i;

	b_ram_red uut
	(
		.pixel_clk(pixel_clk),
		.wea(wea),
		.ena(ena),
		.addra(addra),
		.dina(dina),
		.douta(douta)
	);
	
    always begin 
		#20 pixel_clk <= ~pixel_clk;
    end

	initial begin
		#40
		ena = 1;
		$display("we are reading");
		#300; // ilk baslangıcta LOCKED oluyor
		for(i = 0; i<103148; i=i+1) begin  // douta sonraki veriyi alıyor ama addra sonraki indexe geçemiyor aynı anda waveforma göre. o yuzden konsoldan bak.
			addra = i;
			//#200; // douta için bekle
			$display("Address: %d, Data Read: %h", addra, douta);
			#80; // delay burada olmalı bence. sıkıntı douta ya yazdırmakta değil. Addra adres değiştirmiyor. 
		end
		
		#50;
		$finish;
	end	
endmodule	



`timescale 1ns / 1ps

module tb_controller;

    // Testbench için giriş ve çıkış sinyalleri
    reg pixel_clk;
    reg rst;
    reg enable;
    reg [11:0] data_in;
    wire done;
    wire [16:0] address;
    wire [11:0] kernel1, kernel2, kernel3;
    wire [11:0] pixel1, pixel2, pixel3;

    // Saat sinyali üretimi
    initial begin
        pixel_clk = 0;
        forever #20 pixel_clk = ~pixel_clk; // 10 ns periyotlu saat
    end

    // Reset ve enable sinyali
    initial begin
        rst = 1;
        enable = 0;
        data_in = 12'b0;

        #40 rst = 0;         // Reset sinyalini serbest bırak
        #10 enable = 1;      // Enable sinyalini aktif et
    end

    // Veri girişlerini simüle etme
    initial begin
        #180 data_in = 12'hA12; // İlk veri
        #480 data_in = 12'hB34; // İkinci veri
        #480 data_in = 12'hC56; // Üçüncü veri
        #480 data_in = 12'hD78; // Dördüncü veri
        #480 data_in = 12'hE9A; // Beşinci veri
        #480 data_in = 12'hFAB; // Altıncı veri
    end

    // Simülasyon süresi
    initial begin
        #200000; // 2000 ns boyunca çalıştır
        $stop; // Simülasyonu durdur
    end

    // Test edilen modül örneklemesi
    controller uut (
        .pixel_clk(pixel_clk),
        .rst(rst),
        .enable(enable),
        .data_in(data_in),
        .done(done),
        .address(address),
        .kernel1(kernel1),
        .kernel2(kernel2),
        .kernel3(kernel3),
        .pixel1(pixel1),
        .pixel2(pixel2),
        .pixel3(pixel3)
    );

    // Çıkışların gözlemlenmesi
    initial begin
        $monitor("Time: %0dns, done: %b, address: %d, pixel1: %h, pixel2: %h, pixel3: %h",
                 $time, done, address, pixel1, pixel2, pixel3);
    end

endmodule


module top_module_tb;

  // Clock and reset signals
  reg clk;
  reg rst;

  // VGA outputs
  wire data_en;
  wire VGA_HS;
  wire VGA_VS;
  wire [3:0] VGA_R;
  wire [3:0] VGA_G;  
  wire [3:0] VGA_B;  

  // File descriptors
  integer file_r, file_g, file_b;
  integer row_count = 0;
  integer col_count = 0;

  // Clock generation (100 MHz)
  initial clk = 0;
  always #5 clk = ~clk;  // 100 MHz clock (10 ns period)

  // Instantiate the top module
  top_module uut (
    .clk(clk),
    .rst(rst),
    .VGA_HS(VGA_HS),
    .VGA_VS(VGA_VS),
    .data_en(data_en),
    .VGA_R(VGA_R),
    .VGA_G(VGA_G),
    .VGA_B(VGA_B)
  );

  // Test procedure
  initial begin
    // Open files for writing
    file_r = $fopen("vga_r_output.txt", "w");
    file_g = $fopen("vga_g_output.txt", "w");
    file_b = $fopen("vga_b_output.txt", "w");

    if (file_r == 0 || file_g == 0 || file_b == 0) begin
      $display("Error: Unable to open files for writing.");
      $stop;
    end

    // Reset the system
    rst = 1;
    #100;  // Wait for 100 ns
    rst = 0;

    // Simulate for a sufficient duration
    #5000000;  // Simulate long enough to capture all 482x642 pixels

    // Close files and end simulation
    $fclose(file_r);
    $fclose(file_g);
    $fclose(file_b);
    $stop;
  end

 // Monitor VGA outputs and write to respective files
  always @(posedge clk) begin
    if (!rst && data_en) begin
      // Write pixel data to each file without spaces
      $fwrite(file_r, "%X", VGA_R);
      $fwrite(file_g, "%X", VGA_G);
      $fwrite(file_b, "%X", VGA_B);

      // Increment column count
      col_count = col_count + 1;

      // Check if the end of a row is reached
      if (col_count == 642) begin
        $fwrite(file_r, "\n");  // Newline for the next row in R file
        $fwrite(file_g, "\n");  // Newline for the next row in G file
        $fwrite(file_b, "\n");  // Newline for the next row in B file

        col_count = 0;
        row_count = row_count + 1;

        // Stop writing after 482 rows
        if (row_count == 482) begin
          $fclose(file_r);
          $fclose(file_g);
          $fclose(file_b);
          $stop;
        end
      end
    end
  end

endmodule