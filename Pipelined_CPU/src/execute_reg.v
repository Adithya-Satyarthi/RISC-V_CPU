module execute_reg (
    input clk,
    input reset,
    input flushE,
    input reg_write_enD,
    input [1:0] result_srcD,
    input mem_write_enD,
    input jumpD,
    input branchD,
    input [3:0] alu_controlD,
    input alu_srcD,
    input [31:0] RD1D,
    input [31:0] RD2D,
    input [31:0] pcD,
    input [4:0] rdD,
    input [4:0] RS1D,
    input [4:0] RS2D,
    input [31:0] imm_extD,
    input [31:0] pc_plus_4D,
    output reg reg_write_enE,
    output reg [1:0] result_srcE,
    output reg mem_write_enE,
    output reg jumpE,
    output reg branchE,
    output reg [3:0] alu_controlE,
    output reg alu_srcE,
    output reg [31:0] RD1E,
    output reg [31:0] RD2E,
    output reg [31:0] pcE,
    output reg [4:0] rdE,
    output reg [4:0] RS1E,
    output reg [4:0] RS2E,
    output reg [31:0] imm_extE,
    output reg [31:0] pc_plus_4E
);

always @(posedge clk) begin
    if(reset || flushE) begin
        reg_write_enE <= 0;
        result_srcE <= 2'b0;
        mem_write_enE <= 0;
        jumpE <= 0;
        branchE <= 0;
        alu_controlE <= 4'b0;
        alu_srcE <= 0;
        RD1E <= 32'b0;
        RD2E <= 32'b0;
        pcE <= 32'b0;
        rdE <= 5'b0;
        RS1E <= 5'b0;
        RS2E <= 5'b0;
        imm_extE <= 32'b0;
        pc_plus_4E <= 32'b0;
    end
    else begin
        reg_write_enE <= reg_write_enD;
        result_srcE <= result_srcD;
        mem_write_enE <= mem_write_enD;
        jumpE <= jumpD;
        branchE <= branchD;
        alu_controlE <= alu_controlD;
        alu_srcE <= alu_srcD;
        RD1E <= RD1D;
        RD2E <= RD2D;
        pcE <= pcD;
        rdE <= rdD;
        RS1E <= RS1D;
        RS2E <= RS2D;
        imm_extE <= imm_extD;
        pc_plus_4E <= pc_plus_4D;
    end
end
    
endmodule