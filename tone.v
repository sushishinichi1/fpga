module tone(
    input clk,
    output reg [9:0] wave = 0
);

reg [31:0] c1 = 0;
reg [31:0] c2 = 0;
initial begin
    c1 = 0;
    c2 = 0;
end



always @(posedge clk) begin
    c1 <= c1 + 1;
    c2 <= c2 + 1;

    wave <=
        (c1[8] ? 10'd511 : 10'd0) +
        (c2[8] ? 10'd511 : 10'd0);
end

endmodule
