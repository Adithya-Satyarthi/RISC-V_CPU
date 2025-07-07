`timescale 1ns / 1ps
`default_nettype none

module cpu (
    input clk,
    input reset
);

wire [31:0] pc;
wire [31:0] pc_next;
wire [31:0] pc_target;
wire [31:0] instr;
reg [31:0] result;
wire reg_write_en;
wire [31:0] src_a;
wire [31:0] write_data;
wire branch;
wire jump;
wire mem_read_en;
wire mem_write_en;
wire [1:0] result_src;
wire [1:0] alu_op;
wire alu_src;
wire [31:0] imm_ext;
wire [3:0] alu_control;
wire [31:0] src_b;
wire [31:0] alu_result;
wire zero;
wire [31:0] read_data;


//Program Counter
program_counter programCounter(
    .clk(clk),
    .reset(reset),
    .next_inst(pc_next),
    .curr_inst(pc)
);

//Instruction Memory
instruction_mem instructionMem(
    .address(pc),
    .instruction(instr)
);

//Register File
register_file registerFile(
    .clk(clk),
    .read_index_a(instr[19:15]),
    .read_index_b(instr[24:20]),
    .write_index(instr[11:7]),
    .reg_write(result),
    .reg_write_en(reg_write_en),
    .data_a(src_a),
    .data_b(write_data)
);

//Control Unit
control_unit controlUnit(
    .opcode(instr[6:0]),
    .branch(branch),
    .jump(jump),
    .mem_read_en(mem_read_en),
    .result_src(result_src),
    .alu_op(alu_op),
    .mem_write_en(mem_write_en),
    .alu_src(alu_src),
    .reg_write_en(reg_write_en)
);

//Immediate Generator
imm_gen immediateGen(
    .instruction(instr),
    .immediate(imm_ext)
);

//ALU Control
alu_control_unit aluControl(
    .alu_op(alu_op),
    .funct3(instr[14:12]),
    .funct7(instr[31:25]),
    .alu_control(alu_control)
);

//ALU
alu_unit ALU(
    .operand_a(src_a),
    .operand_b(src_b),
    .alu_control(alu_control),
    .alu_result(alu_result),
    .zero(zero)
);

//Data Memory
data_mem dataMem(
    .clk(clk),
    .mem_read_en(mem_read_en),
    .mem_write_en(mem_write_en),
    .address(alu_result),
    .write_data(write_data),
    .read_data(read_data)
);

//Assigning PCSrc, PCTarget and PCNext
wire pc_src;
wire [31:0] pc_plus_4;
assign pc_src = (branch & zero) | jump;
assign pc_plus_4 = (pc + 32'd4);
assign pc_target = pc + imm_ext;
assign pc_next = pc_src ? pc_target : pc_plus_4;

//Assigning SrcB
assign src_b = alu_src ? imm_ext : write_data;

//Assigning Result
always @(*) begin
    case(result_src)
        2'b00: result = alu_result;
        2'b01: result = read_data;
        2'b10: result = pc_plus_4;
        default: result = 32'b0;
    endcase
end
    
endmodule