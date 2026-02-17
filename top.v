module top(
    input clk,
    input gate,
    input [31:0] f1,
    input [31:0] f2,
    input [31:0] f3,
    input [31:0] f4,
    input update,
    output [15:0] wave_out
);

wire [7:0] w1,w2,w3,w4;

dds d1(clk,f1,update,w1);
dds d2(clk,f2,update,w2);
dds d3(clk,f3,update,w3);
dds d4(clk,f4,update,w4);


/* ===== ミックス ===== */
wire [9:0] mix;
assign mix =
({2'b00,w1}+{2'b00,w2}+{2'b00,w3}+{2'b00,w4}) >> 2;


/* ===== エンベロープ ===== */
reg [15:0] env = 0;
reg [15:0] counter = 0;

always @(posedge clk) begin
    counter <= counter + 1;

    if(counter == 0) begin
        if(gate) begin
            if(env < 16'hFFFF)
                env <= env + 1;
        end
        else begin
            if(env > 0)
                env <= env - 1;
        end
    end
end


/* ===== 音量適用 ===== */
assign wave_out = (mix * env) >> 6;

endmodule
