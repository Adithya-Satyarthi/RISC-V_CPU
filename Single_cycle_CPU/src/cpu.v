`timescale 1ns / 1ps
`default_nettype none

module cpu (
    input clk,
    input reset
);

//------Fetch Stage--------

wire [31:0] pc_nextF;
wire [31:0] pcF;
wire [31:0] instrF;

//Program Counter
program_counter programCounter(
    .clk(clk),
    .reset(reset),
    .next_inst(pc_nextF),
    .curr_inst(pcF)
);

//Instruction Memory
instruction_mem instructionMem(
    .address(pcF),
    .instruction(instrF)
);

wire [31:0] pc_plus_4F;
assign pc_plus_4F = pcF + 32'd4;
assign pc_nextF = pc_srcE ? pc_targetE : pc_plus_4F;

fetch_reg fetchReg(
    .clk(clk),
    .reset(reset),
    .flush(flushF),
    .instrF(instrF),
    .pcF(pcF),
    .pc_plus_4F(pc_plus_4F),
    .instrD(instrD),
    .pcD(pcD),
    .pc_plus_4D(pc_plus_4D)
);

//------------------------

//------Decode Stage------

wire [31:0] pc_nextD;
wire [31:0] pcD;
wire [31:0] instrD;
wire [31:0] RD1D;
wire [31:0] RD2D;
wire [4:0] rdD;
wire [31:0] imm_extD;
wire branchD;
wire jumpD;
wire mem_read_enD;
wire [1:0] result_srcD;
wire [1:0] alu_opD;
wire [3:0] alu_controlD;
wire mem_write_enD;
wire alu_srcD;
wire reg_write_enD;

assign rdD = instrD[11:7];

//Register File
register_file registerFile(
    .clk(clk),
    .read_index_a(instrD[19:15]),
    .read_index_b(instrD[24:20]),
    .write_index(rdW),
    .reg_write(resultW),
    .reg_write_en(reg_write_enW),
    .data_a(RD1D),
    .data_b(RD2D)
);

//Immediate Generator
imm_gen immediateGen(
    .instruction(instrD),
    .immediate(imm_extD)
);

//Control Unit
control_unit controlUnit(
    .opcode(instrD[6:0]),
    .branch(branchD),
    .jump(jumpD),
    .mem_read_en(mem_read_enD),
    .result_src(result_srcD),
    .alu_op(alu_opD),
    .mem_write_en(mem_write_enD),
    .alu_src(alu_srcD),
    .reg_write_en(reg_write_enD)
);

//ALU Control
alu_control_unit aluControl(
    .alu_op(alu_opD),
    .funct3(instrD[14:12]),
    .funct7(instrD[31:25]),
    .alu_control(alu_controlD)
);

decode_reg decodeReg(
    clk(clk),
    reset(reset),
    flush(flushF),
    reg_write_enD(reg_write_enD),
    result_srcD(result_srcD),
    mem_write_enD(mem_write_enD),
    jumpD(jumpD),
    branchD(branchD),
    alu_control(alu_controlD),
    alu_srcD(alu_srcD),
    RD1D(RD1D),
    RD2D(RD2D),
    pcD(pcD),
    rdD(rdD),
    imm_extD(imm_extD),
    pc_plus_4D(pc_plus_4D),
    reg_write_enE(reg_write_enE),
    result_srcE(result_srcE),
    mem_write_enE(mem_write_enE),
    jumpE(jumpE),
    branchE(branchE),
    alu_opE(alu_opE),
    alu_srcE(alu_srcE),
    RD1E(RD1E),
    RD2E(RD2E),
    pcE(pcE),
    rdE(rdE),
    imm_extE(imm_extE),
    pc_plus_4E(pc_plus_4E)
);

//------------------------   

//------Execute Stage-----

wire reg_write_enE;
wire [1:0] result_srcE;
wire mem_write_enE;
wire jumpE;
wire branchE;
wire [3:0] alu_controlE;
wire alu_srcE;
wire [31:0] RD1E;
wire [31:0] RD2E;
wire [31:0] pcE;
wire [31:0] rdE;
wire [31:0] imm_extE;
wire [31:0] pc_plus_4E;
wire pc_srcE;
wire zeroE;
wire [31:0] pc_targetE;
wire [31:0] src_bE;
wire [31:0] alu_resultE;

assign pc_srcE = (branchE & zeroE) | jumpE;
assign pc_targetE = pcE + imm_extE; 
assign src_bE = alu_srcE ? imm_extE : RD2E;

//ALU
alu_unit ALU(
    .operand_a(RD1E),
    .operand_b(src_bE),
    .alu_control(alu_controlE),
    .alu_result(alu_resultE),
    .zeroE(zeroE)
);

execute_reg executeReg(
    .clk(clk),
    .reset(reset),
    .flushE(flushE),
    .reg_write_enE(reg_write_enE),
    .result_srcE(result_srcE),
    .mem_write_enE(mem_write_enE),
    .alu_resultE(alu_resultE),
    .write_dataE(RD2E),
    .rdE(rdE),
    .pc_plus_4E(pc_plus_4E),
    .reg_write_enM(reg_write_enM),
    .result_srcM(result_srcM),
    .mem_write_enM(mem_write_enM),
    .alu_resultM(alu_resultM),
    .write_dataM(write_dataM),
    .rdM(rdM),
    .pc_plus_4M(pc_plus_4M)
);

//------------------------  

//------Memory Stage------

wire reg_write_enM;
wire [1:0] result_srcM;
wire mem_write_enM;
wire [31:0] alu_resultM;
wire [31:0] write_dataM;
wire [4:0] rdM;
wire [31:0] pc_plus_4M;
wire [31:0] read_dataM;

//Data Memory
data_mem dataMem(
    .clk(clk),
    .mem_write_en(mem_write_enM),
    .address(alu_resultM),
    .write_data(write_dataM),
    .read_data(read_dataM)
);

memory_reg memoryReg(
    .clk(clk),
    .reset(reset),
    .flushM(flushM),
    .reg_write_enM(reg_write_enM),
    .result_srcM(result_srcM),
    .alu_resultM(alu_resultM),
    .read_dataM(read_dataM),
    .rdM(rdM),
    .pc_plus_4M(pc_plus_4M),
    .reg_write_enW(reg_write_enW),
    .result_srcW(result_srcW),
    .alu_resultW(alu_resultW),
    .read_dataW(read_dataW),
    .rdW(rdW),
    .pc_plus_4W(pc_plus_4W)
);

//------------------------  

//------Writeback Stage---

wire reg_write_enW;
wire [1:0] result_srcW;
wire [31:0] alu_resultW;
wire [31:0] read_dataW;
wire [4:0] rdW;
wire [31:0] pc_plus_4W;
reg [31:0] resultW;

always @(*) begin
    case(result_srcW)
        2'b00: resultW = alu_resultW;
        2'b01: resultW = read_dataW;
        2'b10: resultW = pc_plus_4W;
        default: resultW = 32'b0;
    endcase
end

//------------------------  

endmodule