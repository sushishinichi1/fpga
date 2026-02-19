`timescale 1ns/1ps

module tb_spi_loopback;

reg clk;
reg rst_n;
reg start;
reg [7:0] tx_data;

wire mosi;
wire sclk;
wire cs_n;
wire busy;

wire [7:0] rx_data;
wire valid;

integer pass = 0;
integer fail = 0;


//====================
// clock
//====================
initial begin
    clk = 0;
    forever #5 clk = ~clk; // 100MHz
end


//====================
// MASTER
//====================
spi_master master (
    .clk(clk),
    .rst_n(rst_n),
    .start(start),
    .data(tx_data),
    .mosi(mosi),
    .sclk(sclk),
    .cs_n(cs_n),
    .busy(busy)
);


//====================
// SLAVE
//====================
spi_slave slave (
    .sclk(sclk),
    .cs_n(cs_n),
    .mosi(mosi),
    .rst_n(rst_n),
    .data(rx_data),
    .valid(valid)
);


//====================
// SEND TASK
//====================
task send_byte(input [7:0] d);
begin
    @(posedge clk);
    tx_data <= d;
    start   <= 1;

    @(posedge clk);
    start   <= 0;

    wait(busy == 1);
    wait(busy == 0);
end
endtask


//====================
// CHECKER
//====================
reg [7:0] expected;

always @(posedge sclk) begin
    if (valid) begin
        if (rx_data == expected) begin
            pass = pass + 1;
            $display("PASS  data=%h  time=%0t", rx_data, $time);
        end
        else begin
            fail = fail + 1;
            $display("FAIL  got=%h expected=%h", rx_data, expected);
        end
    end
end


//====================
// TEST SEQUENCE
//====================
initial begin
    rst_n   = 0;
    start   = 0;
    tx_data = 0;

    #50;
    rst_n = 1;

    @(posedge clk);

    expected = 8'hA5;
    send_byte(expected);

    expected = 8'h3C;
    send_byte(expected);

    expected = 8'hFF;
    send_byte(expected);

    repeat(1000) @(posedge clk);
    #20;

    $display("RESULT  PASS=%0d  FAIL=%0d", pass, fail);
    $finish;
end

endmodule
