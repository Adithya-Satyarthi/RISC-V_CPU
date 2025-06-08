module imm_gen (
    input [31:0] instruction,
    output reg [31:0] immediate
);

wire [6:0] opcode = instruction[6:0];

always @(*) begin
    case (opcode)
        7'b0000011, // I-type: lw
        7'b0010011: // I-type: addi
            immediate = {{20{instruction[31]}}, instruction[31:20]}; // sign-extended 12-bit immediate

        7'b0100011: // S-type: sw
            immediate = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]}; // sign-extended 12-bit immediate

        7'b1100011: // B-type: beq, bne
            immediate = {{19{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0}; // sign-extended 13-bit

        default: immediate = 32'b0;
    endcase
end

endmodule