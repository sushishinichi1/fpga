`timescale 1ns/1ps

module tb;

reg clk=0;
always #5 clk = ~clk;

reg rst=1;
reg start=0;
reg [7:0] data=8'hA5;

wire sclk;
wire mosi;
wire done;

spi_master dut(clk,rst,start,data,sclk,mosi,done);

initial begin
    #20 rst=0;
    #20 start=1;
    #10 start=0;

    wait(done);
    #50 $finish;
end

endmodule
