`timescale 1ns/1ps

module tb_spi_integration;

reg clk;
reg rst_n;
reg start;
reg [7:0] tx_data;

wire sclk;
wire cs_n;
wire mosi;
wire busy;

wire [7:0] rx_data;
wire valid;

integer pass = 0;
integer fail = 0;


// clock
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end


//================ MASTER =================
spi_master master (
    .clk(clk),
    .start(start),
    .rst_n(rst_n),
    .data(tx_data),
    .sclk(sclk),
    .cs_n(cs_n),
    .busy(busy),
    .mosi(mosi),
    .done()
);


//================ SLAVE =================
spi_slave slave (
    .sclk(sclk),
    .cs_n(cs_n),
    .mosi(mosi),
    .rst_n(rst_n),
    .data(rx_data),
    .valid(valid)
);


//================ SEND TASK =================
task send_byte(input [7:0] d);
begin
    @(posedge clk);
    tx_data <= d;
    start   <= 1;

    repeat(3) @(posedge clk);
    start <= 0;

    wait(busy == 1);
    wait(busy == 0);
end
endtask


//================ CHECK =================
reg [7:0] expected;

always @(posedge sclk) begin
    if (valid) begin
        if (rx_data == expected) begin
            pass = pass + 1;
            $display("PASS TX=%h RX=%h", expected, rx_data);
        end else begin
            fail = fail + 1;
            $display("FAIL TX=%h RX=%h", expected, rx_data);
        end
    end
end


//================ TEST =================
initial begin
    rst_n   = 0;
    start   = 0;
    tx_data = 0;

    #50;
    rst_n = 1;
    repeat(2) @(posedge clk);

    expected = 8'hA5;
    send_byte(expected);

    expected = 8'h3C;
    send_byte(expected);

    expected = 8'hFF;
    send_byte(expected);

    #200;

    $display("RESULT PASS=%0d FAIL=%0d", pass, fail);
    $finish;
end

endmodule
