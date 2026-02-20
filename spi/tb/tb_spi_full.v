`default_nettype none
`timescale 1ns/1ps

module tb_spi_full;

initial begin
    #1;
end

reg clk = 0;

always #5 clk = ~clk;
reg rst_n;

initial begin
    rst_n = 0;
    #20 rst_n = 1;
end

reg start;
reg [7:0] master_tx;

wire busy;
wire done;
wire mosi;
wire miso;
wire sclk;
wire cs_n;

reg [7:0] slave_tx;
wire [7:0] slave_rx;
wire slave_valid;
wire [7:0] fifo_dout;



spi_master master (
    .clk(clk),
    .start(start),
    .rst_n(rst_n),
    .data(fifo_dout),
    .miso(miso),
    .sclk(sclk),
    .cs_n(cs_n),
    .busy(busy),
    .mosi(mosi),
    .done(done)
);



spi_slave slave (
    .sclk(sclk),
    .cs_n(cs_n),
    .mosi(mosi),
    .rst_n(rst_n),
    .tx_data(slave_tx),
    .data(slave_rx),
    .valid(slave_valid),
    .miso(miso)
);

simple_fifo fifo (
    .clk(clk),
    .rst_n(rst_n),
    .wr_en(!busy && !fifo_full),
    .wr_data(master_tx),
    .rd_en(!busy && !fifo_empty),
    .rd_data(fifo_dout),
    .full(fifo_full),
    .empty(fifo_empty)
);

wire fifo_full;
wire fifo_empty;

integer pass = 0;
integer fail = 0;

initial begin

    start = 0;
    master_tx = 8'h3A;
    slave_tx  = 8'hC5;

    repeat(3) @(posedge clk);

    wait(!fifo_empty);
    @(posedge clk);
    start = 1;
    @(posedge clk);
    start = 0;

    @(posedge done);

    #1;
    if (slave_rx == master_tx) pass = pass + 1;
    else fail = fail + 1;
    #20;
    $display("PASS=%0d FAIL=%0d RX=%h", pass, fail, slave_rx);
    $finish;
end
endmodule
