`default_nettype none
`timescale 1ns/1ps

module simple_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16,
    parameter ADDR  = 4
)(
    input wire clk,
    input wire rst_n,

    input wire wr_en,
    input wire [WIDTH-1:0] wr_data,

    input wire rd_en,
    output reg  [WIDTH-1:0] rd_data,

    output wire full,
    output wire empty
);

    // ============================================================
    // memory
    // ============================================================
    reg [WIDTH-1:0] mem [0:DEPTH-1];

    // ============================================================
    // pointers
    // ============================================================
    reg [ADDR:0] wr_ptr;
    reg [ADDR:0] rd_ptr;

    wire [ADDR:0] wr_ptr_next;
    wire [ADDR:0] rd_ptr_next;

    assign wr_ptr_next = wr_ptr + (wr_en && !full);
    assign rd_ptr_next = rd_ptr + (rd_en && !empty);

    // ============================================================
    // status flags
    // ============================================================
    assign full  = (wr_ptr[ADDR]      != rd_ptr[ADDR]) &&
                   (wr_ptr[ADDR-1:0] == rd_ptr[ADDR-1:0]);

    assign empty = (wr_ptr == rd_ptr);

    // ============================================================
    // write pointer
    // ============================================================
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            wr_ptr <= { (ADDR+1){1'b0} };
        else
            wr_ptr <= wr_ptr_next;
    end

    // ============================================================
    // memory write
    // ============================================================
    always @(posedge clk) begin
        if (wr_en && !full)
            mem[wr_ptr[ADDR-1:0]] <= wr_data;
    end

    // ============================================================
    // read pointer
    // ============================================================
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            rd_ptr <= { (ADDR+1){1'b0} };
        else
            rd_ptr <= rd_ptr_next;
    end

    // ============================================================
    // read data
    // ============================================================
    always @(posedge clk) begin
        if (rd_en && !empty)
            rd_data <= mem[rd_ptr[ADDR-1:0]];
    end

endmodule

`default_nettype wire