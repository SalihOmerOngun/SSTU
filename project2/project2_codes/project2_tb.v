`timescale 1ns / 1ps

module uart_top_tb;
    reg clk = 1'b0;                  // Saat sinyali
    reg rst = 1'b0;                  // Reset sinyali
    reg [7:0] data_in_tx;           // TX giriş verisi
    reg tx_en = 0;                   // TX etkinleştirme sinyali
    reg rx_en = 0;                   // RX etkinleştirme sinyali
    wire [7:0] data_out_rx;         // RX çıkış verisi
    wire tx_done;                    // TX tamamlanma sinyali
    wire rx_done;                    // RX tamamlanma sinyali
    wire tx_out;                     // TX çıkış sinyali

    // UART top modül örneği
    uart_top uut (
        .clk(clk),
        .rst(rst),
        .data_in_tx(data_in_tx),
        .tx_en(tx_en),
        .rx_en(rx_en),
        .data_out_rx(data_out_rx),
        .tx_done(tx_done),
        .rx_done(rx_done),
        .tx_out(tx_out)
    );

    integer file;                    // Dosya dosya işaretçisi
    reg [7:0] stimulus_data[0:3];    // 4 byte veri dizisi

    // Saat sinyali üretimi
    always #5 clk = ~clk;  // 10ns periyotlu (100 MHz) saat

    initial begin
        // Stimulus dosyasını oku
        file = $fopen("stimulus2.txt", "r");
        if (file == 0) begin
            $display("Error: Cannot open stimulus2.txt");
            $finish;
        end

        // Verileri dosyadan oku
        integer i;
        for (i = 0; i < 4; i = i + 1) begin
            $fscanf(file, "%h\n", stimulus_data[i]);
        end

        $fclose(file);

        rst = 1;    // Reset etkin
        #10;
        rst = 0;    // Reset devre dışı

        // TX ve RX'i başlat
        tx_en = 0;
        rx_en = 1;  // RX aktif et

        // Verileri sırasıyla TX'e gönder
        for (i = 0; i < 4; i = i + 1) begin
            data_in_tx = stimulus_data[i]; // Veriyi TX'e yükle
            tx_en = 1;                      // TX etkinleştir
            #10;                            // Birkaç saat döngüsü bekle
            tx_en = 0;                      // TX devre dışı bırak
            wait(tx_done);                  // TX işlemi tamamlanana kadar bekle

            // RX'in doğru veri aldığını kontrol et
            wait(rx_done);                  // RX işlemi tamamlanana kadar bekle
            if (data_out_rx == stimulus_data[i]) begin
                $display("Data received correctly: %h", data_out_rx);
            end else begin
                $display("Error: Received data %h, expected %h", data_out_rx, stimulus_data[i]);
            end
            #20000;  // Birkaç saat döngüsü bekle
        end

        $finish;  // Test tamamlandı
    end
endmodule


