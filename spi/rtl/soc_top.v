`timescale 1ns/1ps
module soc_top(

    input clk,
    input rst,

    output sclk,
    output mosi,
    input  miso,
    output cs_n

);

// CPUバス信号
wire [31:0] mem_addr;
wire [31:0] mem_wdata;
wire [31:0] mem_rdata;
wire mem_valid;
wire mem_ready;
wire mem_we;

// RAM
wire [31:0] ram_rdata;
reg  [31:0] ram [0:1023];

always @(posedge clk) begin
    if(mem_valid && mem_addr[31:28] == 4'h0) begin
        if(mem_we)
            ram[mem_addr[11:2]] <= mem_wdata;

        ram_rdata <= ram[mem_addr[11:2]];
    end
end

// SPI
wire [31:0] spi_rdata;
wire spi_ack;

spi_wb spi (

    .clk(clk),
    .rst(rst),

    .wb_adr_i(mem_addr),
    .wb_dat_i(mem_wdata),
    .wb_dat_o(spi_rdata),
    .wb_we_i(mem_we),
    .wb_stb_i(mem_valid),
    .wb_ack_o(spi_ack),

    .sclk(sclk),
    .mosi(mosi),
    .miso(miso),
    .cs_n(cs_n)

);

// バス切替
assign mem_rdata =
    (mem_addr[31:28] == 4'h0) ? ram_rdata :
    (mem_addr[31:28] == 4'h1) ? spi_rdata :
    32'h0;

assign mem_ready = 1;

endmodule