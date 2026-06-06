`timescale 1ns/1ps

module tb_soc;

reg clk;
reg rst;

reg [31:0] wb_adr;
reg [31:0] wb_dat_i;
wire [31:0] wb_dat_o;

reg wb_we;
reg wb_cyc;
reg wb_stb;
wire wb_ack;

/* clock */

always #5 clk = ~clk;

/* DUT */

soc_top dut (

.clk(clk),
.rst(rst),

.wb_adr_i(wb_adr),
.wb_dat_i(wb_dat_i),
.wb_dat_o(wb_dat_o),

.wb_we_i(wb_we),
.wb_cyc_i(wb_cyc),
.wb_stb_i(wb_stb),
.wb_ack_o(wb_ack)

);

/* test */

initial begin

clk = 0;
rst = 1;

wb_adr = 0;
wb_dat_i = 0;
wb_we = 0;
wb_cyc = 0;
wb_stb = 0;

#20
rst = 0;

/* RAM write */

#10
wb_adr = 32'h00000004;
wb_dat_i = 32'h12345678;
wb_we = 1;
wb_cyc = 1;
wb_stb = 1;

#10
wb_cyc = 0;
wb_stb = 0;
wb_we = 0;

/* RAM read */

#10
wb_adr = 32'h00000004;
wb_cyc = 1;
wb_stb = 1;

#10
$display("RAM READ = %h", wb_dat_o);

wb_cyc = 0;
wb_stb = 0;

#50
$finish;

end

endmodule