module decode_reg (
    input clk,
    input reset,
    input flushD,
    input stallD,
    input [31:0] instrF,
    input [31:0] pcF,
    input [31:0] pc_plus_4F,
    output reg [31:0] instrD,
    output reg [31:0] pcD,
    output reg [31:0] pc_plus_4D
);

always @(posedge clk) begin
    if(reset || flushD) begin
        instrD <= 32'b0;
        pcD <= 32'b0;
        pc_plus_4D <= 32'b0;
    end
    else if(!stallD) begin
        instrD <= instrF;
        pcD <= pcF;
        pc_plus_4D <= pc_plus_4F;
    end
end
    
endmodule