// tb/tb_dma.v
`timescale 1ns/1ps

module tb_dma;

reg clk;
reg rst;

soc_top uut (
    .clk(clk),
    .rst(rst),

    .wb_adr_i(32'b0),
    .wb_dat_i(32'b0),
    .wb_dat_o(),
    .wb_we_i(1'b0),
    .wb_cyc_i(1'b0),
    .wb_stb_i(1'b0),
    .wb_ack_o()
);

// クロック生成
always #5 clk = ~clk;

initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0, tb_dma);
    clk = 0;
    rst = 1;

    #20;
    rst = 0;

    #200;
    $finish;
end

endmodule