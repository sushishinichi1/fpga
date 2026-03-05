`timescale 1ns/1ps
module spi_wb (
    input  wire        clk,
    input  wire        rst,

    // Wishbone
    input  wire [31:0] wb_adr_i,
    input  wire [31:0] wb_dat_i,
    output reg  [31:0] wb_dat_o,
    input  wire        wb_we_i,
    input  wire        wb_stb_i,
    output reg         wb_ack_o,

    // SPI接続
    output wire        sclk,
    output wire        mosi,
    input  wire        miso,
    output wire        cs_n
);

    reg        start;
    reg [7:0]  tx_data;
    wire       busy;
    wire       done;

    // 既存SPIをそのまま接続
    spi_master u_spi (
        .clk(clk),
        .rst_n(~rst),
        .start(start),
        .data(tx_data),
        .busy(busy),
        .done(done),
        .sclk(sclk),
        .mosi(mosi),
        .miso(miso),
        .cs_n(cs_n)
    );

    // Wishbone制御
    always @(posedge clk) begin
        if (rst) begin
            wb_ack_o <= 0;
            wb_dat_o <= 0;
            start    <= 0;
            tx_data  <= 0;
        end else begin

            wb_ack_o <= 0;

            if (done)
                start <= 0;

        if (wb_stb_i && !wb_ack_o) begin
            wb_ack_o <= 1;

            if (wb_we_i) begin
                case (wb_adr_i[3:0])
                    4'h0: begin
                        tx_data <= wb_dat_i[7:0];
                        start   <= 1;
                    end
                endcase
            end else begin
                case (wb_adr_i[3:0])
                    4'h4: wb_dat_o <= {30'b0, done, busy};
                endcase
            end
        end
    end
    end
endmodule