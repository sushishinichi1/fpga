module consumer (
    input clk,
    input rst_n,

    input  wire fifo_empty,
    input  wire [7:0] fifo_data,
    output reg  fifo_rd_en
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        fifo_rd_en <= 0;
    end else begin
        if (!fifo_empty) begin
            fifo_rd_en <= 1;
        end else begin
            fifo_rd_en <= 0;
        end
    end
end

// ★表示は別alwaysにする
always @(posedge clk) begin
    if (fifo_rd_en) begin
        $display("consume: %d", fifo_data);
    end
end

endmodule