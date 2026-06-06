module simple_ram(

input clk,
input rst,

input [31:0] wb_adr_i,
input [31:0] wb_dat_i,
output reg [31:0] wb_dat_o,

input wb_we_i,
input wb_stb_i,
input wb_cyc_i,
output reg wb_ack_o

);

reg [31:0] mem [0:1023];

wire [9:0] addr = wb_adr_i[11:2];

always @(posedge clk) begin

    wb_ack_o <= 0;

    if (wb_stb_i && wb_stb_i) begin

        wb_ack_o <= 1;

        if (wb_we_i)
            mem[addr] <= wb_dat_i;
        else
            wb_dat_o <= mem[addr];

    end

end

endmodule