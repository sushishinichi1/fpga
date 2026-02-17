module dds(
    input clk,
    input [31:0] freq_in,
    input update,
    output [7:0] wave
);

reg [31:0] phase = 0;
reg [31:0] freq_reg = 0;

always @(posedge clk) begin
    if(update) begin
        freq_reg <= freq_in;
        phase <= 0;
    end
    else begin
        phase <= phase + freq_reg;
    end
end
wire [7:0] saw = phase[31:24];
assign wave = phase[31] ? ~saw : saw;


endmodule
