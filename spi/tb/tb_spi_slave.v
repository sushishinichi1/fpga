`timescale 1ns/1ps

module tb_spi_slave;

reg sclk;
reg cs_n;
reg mosi;
reg rst_n;

wire [7:0] data;
wire valid;

spi_slave uut (
    .sclk(sclk),
    .cs_n(cs_n),
    .mosi(mosi),
    .rst_n(rst_n),
    .data(data),
    .valid(valid)
);

// clock
initial begin
    sclk = 0;
    forever #5 sclk = ~sclk;
end


// SPI送信タスク（正しい版）
task send_byte(input [7:0] byte);
integer i;
begin
    cs_n = 0;

    for (i=7; i>=0; i=i-1) begin
        mosi = byte[i];
        @(posedge sclk);
    end

    cs_n = 1;
    @(posedge sclk);
end
endtask


// test
initial begin
    rst_n = 0;
    cs_n  = 1;
    mosi  = 0;

    #20;
    rst_n = 1;
    repeat(2) @(posedge sclk);

    send_byte(8'hA5);
    send_byte(8'h3C);
    send_byte(8'hFF);

    #50;
    $finish;
end


// monitor
always @(posedge sclk) begin
    if (valid)
        $display("RECEIVED = %h time=%0t", data, $time);
end

endmodule
