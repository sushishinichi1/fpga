`timescale 1ns/1ps

module tb_spi;

reg clk = 0;
reg rst = 1;
reg start = 0;
reg [7:0] data = 0;

wire sclk;
wire mosi;
wire done;

integer pass_count = 0;
integer fail_count = 0;

spi_master uut (
    .clk(clk),
    .rst(rst),
    .start(start),
    .data(data),
    .sclk(sclk),
    .mosi(mosi),
    .done(done)
);

always #5 clk = ~clk;

task send_and_check;
input [7:0] val;
integer i;
reg [7:0] captured;
begin
    data = val;
    start = 1;
    #10;
    start = 0;

    captured = 0;

    // 8bit受信
    for (i=0;i<8;i=i+1) begin
        @(posedge sclk);
        captured = {captured[6:0], mosi};
    end

    wait(done);

    if (captured !== val) begin
        $display("FAIL expected=%h got=%h", val, captured);
        fail_count = fail_count + 1;
    end else begin
        $display("PASS data=%h", val);
        pass_count = pass_count + 1;
    end

    #20;
end
endtask

initial begin
    #20 rst = 0;

    send_and_check(8'hA5);
    send_and_check(8'h3C);
    send_and_check(8'hF0);
    send_and_check(8'h0F);

    #50;

    $display("==== RESULT ====");
    $display("PASS=%0d FAIL=%0d", pass_count, fail_count);

    if (fail_count > 0)
        $fatal;
    else
        $finish;
end

endmodule
