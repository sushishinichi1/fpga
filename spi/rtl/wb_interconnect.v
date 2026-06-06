`timescale 1ns/1ps
module wb_interconnect(

input clk,
input rst,

/* master side */

input [31:0] m_adr_i,
input [31:0] m_dat_i,
output [31:0] m_dat_o,

input m_we_i,
input m_cyc_i,
input m_stb_i,
output m_ack_o,

/* RAM */

output [31:0] ram_adr_o,
output [31:0] ram_dat_o,
input  [31:0] ram_dat_i,

output ram_we_o,
output ram_cyc_o,
output ram_stb_o,
input  ram_ack_i,

/* SPI */

output [31:0] spi_adr_o,
output [31:0] spi_dat_o,
input  [31:0] spi_dat_i,

output spi_we_o,
output spi_cyc_o,
output spi_stb_o,
input  spi_ack_i

);

/* address decode */

wire sel_ram = (m_adr_i[31:28] == 4'h0);
wire sel_spi = (m_adr_i[31:28] == 4'h1);

/* forward signals */

assign ram_adr_o = m_adr_i;
assign ram_dat_o = m_dat_i;
assign ram_we_o  = m_we_i;
assign ram_cyc_o = m_cyc_i & sel_ram;
assign ram_stb_o = m_stb_i & sel_ram;

assign spi_adr_o = m_adr_i;
assign spi_dat_o = m_dat_i;
assign spi_we_o  = m_we_i;
assign spi_cyc_o = m_cyc_i & sel_spi;
assign spi_stb_o = m_stb_i & sel_spi;

/* return path */

assign m_dat_o =
    sel_ram ? ram_dat_i :
    sel_spi ? spi_dat_i :
    32'h00000000;

assign m_ack_o =
    sel_ram ? ram_ack_i :
    sel_spi ? spi_ack_i :
    1'b0;

endmodule