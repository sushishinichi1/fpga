module spi_slave (
    input  wire       sclk,
    input  wire       cs_n,
    input  wire       mosi,
    input  wire       rst_n,

    output reg [7:0]  data,
    output reg        valid
);

reg [7:0] shift_reg;
reg [2:0] bit_cnt;

always @(negedge sclk or negedge rst_n) begin
    if (!rst_n) begin
        shift_reg <= 0;
        bit_cnt   <= 0;
        data      <= 0;
        valid     <= 0;
    end
    else begin
        valid <= 0;
        if (cs_n) begin
            bit_cnt <= 0;
            valid   <= 0;
        end
        else begin
            shift_reg <= {shift_reg[6:0], mosi};

            if (bit_cnt == 3'd7) begin
                data    <= {shift_reg[6:0], mosi};
                valid   <= 1;
                bit_cnt <= 0;
            end
            else begin
                valid <= 0;
                bit_cnt <= bit_cnt + 1;
                valid   <= 0;
            end
        end
    end
end

endmodule
