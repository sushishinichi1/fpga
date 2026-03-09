`default_nettype none
`timescale 1ns/1ps

module tb_spi_full;

initial begin
    #1;
#2000000;
$finish;
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
reg start_req;
reg ready;

reg [7:0] slave_tx;
wire [7:0] slave_rx;
wire slave_valid;
wire [7:0] fifo_dout;
reg [7:0] sent_data;
reg [7:0] fifo_hold;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        fifo_hold <= 0;
    else if(!busy && !fifo_empty) 
        fifo_hold <= fifo_dout;
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        start <= 0;
        sent_data <= 0;
    end
    else begin
        start <= start_req;
        if(start_req)
            sent_data <= fifo_dout;
    end
end
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        start_req <= 0;
    else
        start_req <= (!busy && !fifo_empty);
end
always @(posedge clk) begin
    ready <= (!busy && !fifo_empty);

start_req <= ready;
end

spi_master master (
    .clk(clk),
    .start(start),
    .rst_n(rst_n),
    .data(fifo_hold),
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
    .wr_en(!fifo_full),
    .wr_data(master_tx),
    .rd_en(!fifo_empty && !busy && !start),
    .rd_data(fifo_dout),
    .full(fifo_full),
    .empty(fifo_empty)
);

wire fifo_full;
wire fifo_empty;

integer pass = 0;
integer fail = 0;
integer count = 0;

initial begin
    start = 0;
    repeat(4) begin
        @(posedge clk);
        master_tx = $random;
    end
    slave_tx  = 8'hC5;

    repeat(3) @(posedge clk);

    
    @(posedge done);

    #1;
    repeat(4) begin
        @(posedge done);
        sent_data = fifo_dout;
        #1;
        if (slave_rx == sent_data)
            pass = pass + 1;
        else begin
            fail = fail + 1;
            $display("FAIL sent=%h recv=%h fifo=%h time=%0t",
                    sent_data, slave_rx, fifo_dout, $time);
        end
        count = count + 1;
    end
    #20;
    $display("PASS=%0d FAIL=%0d RX=%h", pass, fail, slave_rx);
    $finish;
end
endmodule
