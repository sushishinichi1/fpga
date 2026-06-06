`timescale 1ns/1ps
module soc_top(

input clk,
input rst,

input  [31:0] wb_adr_i,
input  [31:0] wb_dat_i,
output [31:0] wb_dat_o,

input wb_we_i,
input wb_cyc_i,
input wb_stb_i,
output wb_ack_o

);


initial begin
    ram[0] = 10;
    ram[1] = 20;
    ram[2] = 30;
    ram[3] = 40;
end
reg [31:0] dma_rdata_reg;

always @(posedge clk) begin
    dma_rdata_reg <= ram[dma_addr];
end

assign dma_rdata = dma_rdata_reg;

// CPUバス信号
wire [31:0] mem_addr;
wire [31:0] mem_wdata;
wire [31:0] mem_rdata;
wire mem_valid;
wire mem_ready;
wire mem_we;
wire fifo_full;
wire fifo_we;
wire [7:0] fifo_data;
wire [7:0] dma_addr;
wire [31:0] dma_rdata;

wire fifo_empty;
wire fifo_rd_en;

simple_fifo fifo (
    .clk(clk),
    .rst_n(~rst),

    .wr_en(fifo_we),
    .wr_data(fifo_data),

    .rd_en(fifo_rd_en),
    .rd_data(fifo_data),

    .full(fifo_full),
    .empty(fifo_empty)
);

consumer cons (
    .clk(clk),
    .rst_n(~rst),

    .fifo_empty(fifo_empty),
    .fifo_data(fifo_data),
    .fifo_rd_en(fifo_rd_en)
);

// RAM
reg [31:0] ram_rdata;
reg  [31:0] ram [0:1023];

dma_engine dma (
    .clk(clk),
    .rst_n(~rst),

    .ram_addr(dma_addr),
    .ram_data(dma_rdata[7:0]),

    .fifo_full(fifo_full),
    .fifo_we(fifo_we),
    .fifo_data(fifo_data)
);

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

// spi_wb spi (

//     .clk(clk),
//     .rst(rst),

//     .wb_adr_i(mem_addr),
//     .wb_dat_i(mem_wdata),
//     .wb_dat_o(spi_rdata),
//     .wb_we_i(mem_we),
//     .wb_stb_i(mem_valid),
//     .wb_ack_o(spi_ack),

//     .sclk(sclk),
//     .mosi(mosi),
//     .miso(miso),
//     .cs_n(cs_n)

// );

// バス切替
assign mem_rdata =
    (mem_addr[31:28] == 4'h0) ? ram_rdata :
    (mem_addr[31:28] == 4'h1) ? spi_rdata :
    32'h0;

assign mem_ready = 1;

endmodule