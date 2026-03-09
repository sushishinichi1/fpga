`timescale 1ns/1ps

module tb_spi_wb;

reg clk = 0;
always #5 clk = ~clk;

reg rst = 1;

reg [31:0] wb_adr_i;
reg [31:0] wb_dat_i;
wire [31:0] wb_dat_o;
reg wb_we_i;
reg wb_stb_i;
wire wb_ack_o;

wire sclk;
wire mosi;
wire miso;
wire cs_n;

assign miso = 0;

// DUT
spi_wb dut (
    .clk(clk),
    .rst(rst),

    .wb_adr_i(wb_adr_i),
    .wb_dat_i(wb_dat_i),
    .wb_dat_o(wb_dat_o),
    .wb_we_i(wb_we_i),
    .wb_stb_i(wb_stb_i),
    .wb_ack_o(wb_ack_o),

    .sclk(sclk),
    .mosi(mosi),
    .miso(miso),
    .cs_n(cs_n)
);

initial begin

    wb_adr_i = 0;
    wb_dat_i = 0;
    wb_we_i  = 0;
    wb_stb_i = 0;
    

    #20;
    rst = 0;

    // SPI送信開始
    #20;
    wb_adr_i = 32'h0;
    wb_dat_i = 32'h63;
    wb_we_i  = 1;
    wb_stb_i = 1;

    #20;
    wb_stb_i = 0;
    wb_we_i  = 0;

    // ステータス読む
    #200;

    wb_adr_i = 32'h4;
    wb_stb_i = 1;

    #10;
    wb_stb_i = 0;

    #100;

    $display("STATUS=%h", wb_dat_o);

    #100;
    $finish;

end

endmodule