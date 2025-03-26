`timescale 1ns/1ps


module REGISTER_BLOCK
(
    input clk,
    input rst,
    input [7:0] inA,
    input [7:0] inB,
    input [7:0] cu_const,
    input [2:0] in_mux_add,
    input [3:0] out_mux_add,
    input [3:0] reg_add,
    input we,
    input [7:0] alu_out,
    output [7:0] alu_in_a,
    output [7:0] alu_in_b,
    output [7:0] out
);

    wire [15:0] decoder_out;
    wire [7:0] out_mux_out;
    wire [7:0] in_mux_out;
    wire [7:0] re_out0, re_out1, re_out2, re_out3, re_out4, re_out5,re_out6;

    // DECODER instantiation
    DECODER decoder 
    (
        .reg_add(reg_add),
        .we(we),
        .OUT(decoder_out)
    );

    // IN_MUX instantiation
    IN_MUX u_in_mux 
    (
        .D0(inA),
        .D1(inB),
        .D2(cu_const),
        .D3(alu_out),
        .D4(out_mux_out),
        .D5(out_mux_out),
        .D6(out_mux_out),
        .D7(out_mux_out),
        .in_mux_add(in_mux_add),
        .O(in_mux_out)
    );

    // OUT_MUX instantiation
    OUT_MUX u_out_mux 
    (
        .D0(re_out0),
        .D1(re_out1),
        .D2(re_out2),
        .D3(re_out3),
        .D4(re_out4),
        .D5(re_out5),
        .D6(re_out6), // yeniii new control unit ile 
        .D7(8'b0),
        .D8(8'b0),
        .D9(8'b0),
        .D10(8'b0),
        .D11(8'b0),
        .D12(8'b0),
        .D13(8'b0),
        .D14(8'b0),
        .D15(8'b0),
        .out_mux_add(out_mux_add),
        .O(out_mux_out)
    );

    // REGISTER instantiations
    REGISTER reg0
    (
        .clk(clk),
        .rst(rst),
        .rin(in_mux_out),
        .en(decoder_out[0]),
        .rout(re_out0)
    );

    REGISTER reg1
    (
        .clk(clk),
        .rst(rst),
        .rin(in_mux_out),
        .en(decoder_out[1]),
        .rout(re_out1)
    );

    REGISTER reg2
    (
        .clk(clk),
        .rst(rst),
        .rin(in_mux_out),
        .en(decoder_out[2]),
        .rout(re_out2)
    );

    REGISTER reg3
    (
        .clk(clk),
        .rst(rst),
        .rin(in_mux_out),
        .en(decoder_out[3]),
        .rout(re_out3)
    );

    REGISTER reg4
    (
        .clk(clk),
        .rst(rst),
        .rin(in_mux_out),
        .en(decoder_out[4]),
        .rout(re_out4)
    );

    REGISTER reg5
    (
        .clk(clk),
        .rst(rst),
        .rin(in_mux_out),
        .en(decoder_out[5]),
        .rout(re_out5)
    );
	
    REGISTER reg6 // yeniii new control unit ile 
    (
        .clk(clk),
        .rst(rst),
        .rin(in_mux_out),
        .en(decoder_out[6]),
        .rout(re_out6)
    );	

    // Output assignment
    assign alu_in_a = re_out1; 
    assign alu_in_b = re_out2; 
    assign out = re_out0;

endmodule


module DECODER
(
    input [3:0] reg_add,
    input we,                // write enable sinyali
    output [15:0] OUT
);

    reg [15:0] out_reg;

    always @(*)
    begin
        if (we) begin         // we sinyali 1 ise çalışır
            case(reg_add)
                4'b0000: out_reg = 16'b0000_0000_0000_0001;
                4'b0001: out_reg = 16'b0000_0000_0000_0010;
                4'b0010: out_reg = 16'b0000_0000_0000_0100;
                4'b0011: out_reg = 16'b0000_0000_0000_1000;
                4'b0100: out_reg = 16'b0000_0000_0001_0000;
                4'b0101: out_reg = 16'b0000_0000_0010_0000;
                4'b0110: out_reg = 16'b0000_0000_0100_0000;
                4'b0111: out_reg = 16'b0000_0000_1000_0000;
                4'b1000: out_reg = 16'b0000_0001_0000_0000;
                4'b1001: out_reg = 16'b0000_0010_0000_0000;
                4'b1010: out_reg = 16'b0000_0100_0000_0000;
                4'b1011: out_reg = 16'b0000_1000_0000_0000;
                4'b1100: out_reg = 16'b0001_0000_0000_0000;
                4'b1101: out_reg = 16'b0010_0000_0000_0000;
                4'b1110: out_reg = 16'b0100_0000_0000_0000;
                4'b1111: out_reg = 16'b1000_0000_0000_0000;
                default: out_reg = 16'b0000_0000_0000_0000;
            endcase
        end else begin         // we sinyali 0 ise çıkış sıfırlanır
            out_reg = 16'b0000_0000_0000_0000;
        end
    end

    assign OUT = out_reg;

endmodule


module IN_MUX
(
    input [7:0] D0,
    input [7:0] D1,
    input [7:0] D2,
    input [7:0] D3,
    input [7:0] D4,
    input [7:0] D5,
    input [7:0] D6,
    input [7:0] D7,
    input [2:0] in_mux_add, // 3-bit seçim girişi
    output reg [7:0] O      // 8-bit çıkış
);

    always @(*)
    begin
        case (in_mux_add)
            3'b000: O = D0;
            3'b001: O = D1;
            3'b010: O = D2;
            3'b011: O = D3;
            3'b100: O = D4;
            3'b101: O = D5;
            3'b110: O = D6;
            3'b111: O = D7;
            default: O = 8'b0; // Güvenlik için bir default durumu ekledik
        endcase
    end

endmodule


module OUT_MUX
(
    input [7:0] D0,
    input [7:0] D1,
    input [7:0] D2,
    input [7:0] D3,
    input [7:0] D4,
    input [7:0] D5,
    input [7:0] D6,
    input [7:0] D7,
    input [7:0] D8,
    input [7:0] D9,
    input [7:0] D10,
    input [7:0] D11,
    input [7:0] D12,
    input [7:0] D13,
    input [7:0] D14,
    input [7:0] D15,
    input [3:0] out_mux_add, // 4-bit seçim girişi
    output reg [7:0] O       // 8-bit çıkış
);

    always @(*)
    begin
        case (out_mux_add)
            4'b0000: O = D0;
            4'b0001: O = D1;
            4'b0010: O = D2;
            4'b0011: O = D3;
            4'b0100: O = D4;
            4'b0101: O = D5;
            4'b0110: O = D6;
            4'b0111: O = D7;
            4'b1000: O = D8;
            4'b1001: O = D9;
            4'b1010: O = D10;
            4'b1011: O = D11;
            4'b1100: O = D12;
            4'b1101: O = D13;
            4'b1110: O = D14;
            4'b1111: O = D15;
            default: O = 8'b0; // Default durumu, güvenlik için
        endcase
    end

endmodule


module REGISTER
(
	input clk,
	input rst,
	input [7:0] rin,
	input en,
	output reg [7:0] rout
);
	//reg [7:0] data;

	always @( posedge clk or posedge rst) begin

		if (rst == 1'b1) begin
				rout <= 8'b0;
		end
		
		else begin
			if (en == 1'b1) begin
				rout <= rin;
			end	
		end
	end 

endmodule
	