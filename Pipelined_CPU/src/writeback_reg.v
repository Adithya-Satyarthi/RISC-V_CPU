module writeback_reg (
    input clk,
    input reset,
    input reg_write_enM,
    input [1:0] result_srcM,
    input [31:0] alu_resultM,
    input [31:0] read_dataM,
    input [4:0] rdM,
    input [31:0] pc_plus_4M,
    output reg reg_write_enW,
    output reg [1:0] result_srcW,
    output reg [31:0] alu_resultW,
    output reg [31:0] read_dataW,
    output reg [4:0] rdW,
    output reg [31:0] pc_plus_4W
);

always @(posedge clk) begin
    if(reset) begin
        reg_write_enW <= 1'b0;
        result_srcW <= 2'b0;
        alu_resultW <= 32'b0;
        read_dataW <= 32'b0;
        rdW <= 5'b0;
        pc_plus_4W <= 32'b0;
    end
    else begin
        reg_write_enW <= reg_write_enM;
        result_srcW <= result_srcM;
        alu_resultW <= alu_resultM;
        read_dataW <= read_dataM;
        rdW <= rdM;
        pc_plus_4W <= pc_plus_4M;
    end
end
    
endmodule