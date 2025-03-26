`timescale 1ns/1ps

module control_unit_tb;

  // Testbench için sinyaller
  reg clk;
  reg rst;
  reg start;
  reg co;
  reg z;
  wire busy;
  wire [1:0] insel;
  wire [7:0] cu_const;
  wire [2:0] in_mux_add;
  wire [3:0] out_mux_add;
  wire [3:0] reg_add;
  wire we;

  // DUT (Design Under Test) bağlanıyor
  control_unit uut (
    .clk(clk),
    .rst(rst),
    .start(start),
    .co(co),
    .z(z),
    .busy(busy),
    .insel(insel),
    .cu_const(cu_const),
    .in_mux_add(in_mux_add),
    .out_mux_add(out_mux_add),
    .reg_add(reg_add),
    .we(we)
  );

  // Saat sinyali üretimi
  initial begin
    clk = 0;
    forever #5 clk = ~clk; // 10 ns periyotlu saat
  end

  // Test senaryoları
  initial begin
    // Başlangıç durumu
    rst = 1; start = 0; co = 0; z = 0;
    #10;
    rst = 0;

    // START sinyali ile başlatma
    #10 start = 1;
    #10 start = 0;

    // ZERO durumunu test et
    #20 z = 1; // Z sinyalini 1 yaparak DONE durumunu tetikleyin
    #20 z = 0;

    // EXP_SUB durumunu test et
    #20 co = 1; z = 0; // Carry-out (co) ve Z sinyal kombinasyonlarını değiştir
    #30 z = 1; // Z = 1 olduğunda DONE durumuna geçiş

    // Simülasyonu sonlandır
    #50 $finish;
  end

  // Değişiklikleri gözlemlemek için
  initial begin
    $monitor("Time: %0t | State: %b | busy: %b | we: %b | insel: %b | reg_add: %b | in_mux_add: %b | out_mux_add: %b", 
              $time, uut.state, busy, we, insel, reg_add, in_mux_add, out_mux_add);
  end

endmodule
