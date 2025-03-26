`timescale 1ns / 1ps

module uart_tx_tb;

    // Testbench parametreleri
    parameter [16:0] freq = 115200;
    reg clk = 1'b0;          // Saat sinyali
    reg rst = 1'b0;          // Reset sinyali
    reg [7:0] d_in;          // UART girişi verisi
    reg tx_en = 1'b0;        // UART iletim etkinleştirme sinyali
    wire seri_out;           // UART seri çıkışı
    wire done;               // Gönderim tamamlandı sinyali

    integer file, r;         // Dosya işlemleri için integer
    reg [7:0] stimulus_data; // Dosyadan okunan veri
    integer i;               // Döngü kontrolü

    // UART modül örneği
    uart_tx #(.freq(freq)) uut (
        .clk(clk),
        .rst(rst),
        .d_in(d_in),
        .tx_en(tx_en),
        .seri_out(seri_out),
        .done(done)
    );

    // Saat sinyali üretimi
    always #5 clk = ~clk; // 10ns periodlu (100 MHz) saat sinyali

    initial begin
        // Stimulus dosyasını aç
        file = $fopen("stimulus2.txt", "r");
        if (file == 0) begin
            $display("Error: Cannot open stimulus2.txt");
            $finish;
        end

        rst = 1;   // Reset etkin
        d_in = 8'b0;      // Veri sıfırlama
        tx_en = 0;        // İletim devre dışı
        #8000;              // Birkaç saat döngüsü bekle

        // Reset devre dışı
        rst = 0;

        // Stimulus dosyasındaki verileri oku ve gönder
        for (i = 0; i < 4; i = i + 1) begin
            // Dosyadan bir bayt oku
            r = $fscanf(file, "%b\n", stimulus_data);
            
            if (r == 1) begin // Veriyi başarılı bir şekilde okuduysak
                d_in = stimulus_data; // Veriyi d_in'e ata
                tx_en = 1;             // İletim etkinleştir
                #10;                   // Birkaç saat döngüsü bekle
                tx_en = 0;             // İletim devre dışı

                // Veri gönderiminin tamamlanmasını bekle
                wait (done == 1);
                #15000; // Verinin tamamlanmasını bekle
            end
        end

        // Test tamamlandı
        $fclose(file); // Dosyayı kapat
        $finish;
    end

endmodule




module baud_gen_tb();

    // Parameters
    parameter [16:0] freq = 115200;

    // Testbench Signals
    reg clk = 1'b0;    // Clock
    reg rst = 1'b0;    // Reset
    reg baud_en = 1'b0; // Enable signal
    wire count_8x_ready; // 8x clock ready
    wire count_baud_ready; // Baud clock ready

    // Instantiate the DUT (Device Under Test)
    baud_gen #(.freq(freq)) uut (
        .clk(clk),
        .rst(rst),
        .baud_en(baud_en),
        .count_8x_ready(count_8x_ready),
        .count_baud_ready(count_baud_ready)
    );

    // Generate a 100 MHz clock (period = 10 ns)
    always begin
        #5 clk = ~clk;  
    end

    // Test Sequence
    initial begin
        // Reset and initialization
        rst = 1;  
        #10;      
        rst = 0;  
        
        // Enable baud generation
        baud_en = 1;
        
        // Wait for some time to observe outputs
        #104200; 
        
        // Disable baud generation
        baud_en = 0;
        
        // Wait for a short period and finish
        #200;
        $finish;
    end

endmodule

module uart_rx_tb;

    parameter freq = 115200; // Baud rate
    reg clk = 0;
    reg rst = 0;
    reg d_in = 1; // IDLE STATE
    reg rx_en = 0;
    wire [7:0] d_out;
    wire done;
    reg [7:0] test_data; // 8-bit test verisi
    reg [7:0] expected_data;
    integer file, i;
    // Clock Ã¼retimi (100 MHz clock, 10 ns period)
    
	always #5 clk = ~clk;

    // Test edilen UART RX modÃ¼lÃ¼
    uart_rx #(.freq(freq)) uut (
        .clk(clk),
        .rst(rst),
        .d_in(d_in),
        .rx_en(rx_en),
        .d_out(d_out),
        .done(done)
    );

    // UART veri gÃ¶nderim simÃ¼lasyonu
    task send_uart_byte(input [7:0] para_in);
        integer i;
        begin
            // Start bit (0)
            d_in = 0;
			rx_en = 1;
            #(8640); // T_baud sÃ¼resi

            // Data bitleri (LSB'den MSB'ye)
            for (i = 0; i < 8; i = i + 1) begin
                d_in = para_in[i];
                #(8640);
            end

            // Stop bit (1)
            d_in = 1;
            #(8640);
        end
    endtask

    // Test senaryosu
    initial begin
        file = $fopen("stimulus2.txt", "r");
        if (file == 0) begin
            $display("Error: Cannot open stimulus2.txt");
            $finish;
        end

        $display("Starting UART RX testbench...");
        rst = 1;
        #10000;
        rst = 0;
        rx_en = 0;
        #45;

        i = 0;
        while (!$feof(file)) begin
            $fscanf(file, "%b\n", test_data);
            expected_data = test_data;

            rx_en = 1;  // RX etkinleştir
            send_uart_byte(test_data);

            #100; // posedge done, wait done dersen. Done sinyali send_uart_byte icinde 1 olduğu için fonksiyondan çıkınca 0 oluyor. wait kısmına girince 0 oluyor çalışmıyor.
			
			
            rx_en = 0;  // Yeni veri için devreyi sıfırla
            #60;

            if (d_out == expected_data) begin
                $display("Test %0d Passed! Sent: %b, Received: %b", i + 1, expected_data, d_out);
            end else begin
                $display("Test %0d Failed! Sent: %b, Received: %b", i + 1, expected_data, d_out);
            end

            i = i + 1; // Sayaç doğru artırılıyor
        end

        $display("Test completed!");
        $fclose(file);
        $finish;
    end

endmodule