module alu_control_unit (
    input [1:0] alu_op,
    input [2:0] funct3,
    input [6:0] funct7,
    output reg [3:0] alu_control
);

always @(*) begin
    case(alu_op)
        2'b00: alu_control = 4'b0000; //ADD //For load and store
        2'b01: alu_control = 4'b0001; //SUB //For branch type
        2'b10: begin // R-Type
            case(funct3)
                3'b000: alu_control = (funct7[5] == 1'b1) ? 4'b0001 : 4'b0000; //ADD or SUB based on funct7
                3'b111: alu_control = 4'b0010; // AND
                3'b110: alu_control = 4'b0011; // OR
                3'b100: alu_control = 4'b0100; // XOR
                3'b010: alu_control = 4'b0101; // SLT
                3'b011: alu_control = 4'b0110; // SLTU
                3'b001: alu_control = 4'b0111; // SLL
                3'b101: alu_control = (funct7[5] == 1'b1) ? 4'b1001 : 4'b1000; //SRA or SRL based on func7
                default: alu_control = 4'b0000;
            endcase
        end
        2'b11: begin // Immediate Type 
            case(funct3)
                3'b000: alu_control = 4'b0000; //addi
                3'b001: alu_control = (funct7 == 7'b0) ? 4'b0111 : 4'b0000; //slli 
                3'b010: alu_control = 4'b0101; //slti
                3'b011: alu_control = 4'b0110; // sltui
                3'b100: alu_control = 4'b0100; //xori
                3'b101: alu_control = (funct7[5] == 1'b1) ? 4'b1001 : 4'b1000; //srai or srli
                3'b110: alu_control = 4'b0011; //ori
                3'b111: alu_control = 4'b0010; //andi
                default: alu_control = 4'b0000;
            endcase
        end
        default: alu_control = 4'b0000;
    endcase
end

endmodule