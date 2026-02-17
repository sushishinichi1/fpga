module top(
    input clk,
    output [7:0] out
);

reg [31:0] phase /* verilator public */;
reg [31:0] freq  /* verilator public */ = 32'd1000000;

always @(posedge clk)
begin
    phase <= phase + freq;
end

assign out = phase[31] ? ~phase[30:23] : phase[30:23];

endmodule
