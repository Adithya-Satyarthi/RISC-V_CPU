module control_unit (
    input [6:0] opcode,
    output reg branch,
    output reg jump,
    output reg mem_read_en,
    output reg [1:0] result_src,
    output reg [1:0] alu_op,
    output reg mem_write_en,
    output reg alu_src,
    output reg reg_write_en
);

always @(*) begin
    case(opcode)
        7'b0110011: begin // R-Type
            alu_src = 0;
            result_src = 2'b00;
            reg_write_en = 1;
            mem_read_en = 0;
            mem_write_en = 0;
            branch = 0;
            alu_op = 2'b10;
            jump = 0;
        end
        7'b0010011: begin // Immediate
            alu_src = 1;
            result_src = 2'b00;
            reg_write_en = 1;
            mem_read_en = 0;
            mem_write_en = 0;
            branch = 0;
            alu_op = 2'b11;
            jump = 0;
        end
        7'b0000011: begin // Load
            alu_src = 1;
            result_src = 2'b01;
            reg_write_en = 1;
            mem_read_en = 1;
            mem_write_en = 0;
            branch = 0;
            alu_op = 2'b00;
            jump = 0;
        end
        7'b0100011: begin // Store
            alu_src = 1;
            result_src = 2'b00;
            reg_write_en = 0;
            mem_read_en = 0;
            mem_write_en = 1;
            branch = 0;
            alu_op = 2'b00;
            jump = 0;
        end
        7'b1100011: begin // beq
            alu_src = 0;
            result_src = 2'b00;
            reg_write_en = 0;
            mem_read_en = 0;
            mem_write_en = 0;
            branch = 1;
            alu_op = 2'b01;
            jump = 0;
        end
        7'b1101111: begin // J-Type
            alu_src = 0;
            result_src = 2'b10;
            reg_write_en = 1;
            mem_read_en = 0;
            mem_write_en = 0;
            branch = 0;
            alu_op = 2'b00;
            jump = 1;
        end
        default: begin
            alu_src = 0;
            result_src = 0;
            reg_write_en = 0;
            mem_read_en = 0;
            mem_write_en = 0;
            branch = 0;
            alu_op = 2'b00; 
            jump = 0;
        end
    endcase
end
    
endmodule
