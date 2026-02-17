module counter (
    input clk,
    output reg [31:0] cnt,
    output audio
);

// 時間カウンタ
always @(posedge clk) begin
    cnt <= cnt + 1;
end

// ===== テンポ生成 =====
wire [3:0] step = cnt[24:21];

// ===== 音階テーブル =====
reg [4:0] note;

always @(*) begin
    case(step)
        0: note = 4;
        1: note = 6;
        2: note = 8;
        3: note = 11;
        4: note = 8;
        5: note = 6;
        6: note = 4;
        default: note = 1;
    endcase
end

// ===== 音生成 =====
wire tone = cnt[note];

// ===== 出力 =====
assign audio = tone;

endmodule
