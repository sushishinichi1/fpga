// rtl/dma_engine.v（テスト用）
module dma_engine (
    input clk,
    input rst_n,

    output reg [7:0] ram_addr,
    input      [7:0] ram_data,

    input  wire fifo_full,
    output reg  fifo_we,
    output reg [7:0] fifo_data
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        fifo_we   <= 0;
        fifo_data <= 0;
    end else begin
        if (!fifo_full) begin
            fifo_we   <= 1;
            fifo_data <= 8'd99;   // ★固定値
        end else begin
            fifo_we <= 0;
        end
    end
end

endmodule