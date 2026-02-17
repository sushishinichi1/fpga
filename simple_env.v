module simple_env(
    input clk,
    input gate,
    output reg [9:0] level
);

parameter ATTACK  = 4;
parameter RELEASE = 2;

initial begin
    level = 0;
end

always @(posedge clk) begin
    if(gate) begin
        if(level < 1023)
            level <= level + ATTACK;
    end
    else begin
        if(level > 0)
            level <= level - RELEASE;
    end
end

endmodule
