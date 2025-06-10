module imm_gen (
    input [31:0] instruction,
    output reg [31:0] immediate
);

wire [6:0] opcode;
assign opcode = instruction[6:0];

always @(*) begin
    case (opcode)
        7'b0000011: // I-type: lw
            immediate = {{20{instruction[31]}}, instruction[31:20]}; // sign-extended 12-bit to 32 bits immediate
        7'b0010011: // Immediate Type
            case(instruction[14:12])
                3'b001,
                3'b101: immediate = {27'b0, instruction[24:20]}; // 0 extended to unsigned 32 bit
                default: immediate = {{20{instruction[31]}}, instruction[31:20]}; // sign-extended 12-bit to 32 bits immediate
            endcase
        7'b0100011: // S-type: sw
            immediate = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]}; // sign-extended 12-bit immediate

        7'b1100011: // B-type: beq, bne
            immediate = {{19{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0}; // sign-extended 
        7'b1101111: //J-Type
            immediate = {{12{instruction[31]}}, instruction[19:12], instruction[20], instruction[30:21], 1'b0};

        default: immediate = 32'b0;
    endcase
end

endmodule