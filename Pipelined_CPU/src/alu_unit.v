module alu_unit (
    input [31:0] operand_a,
    input [31:0] operand_b,
    input [3:0] alu_control,
    output reg [31:0] alu_result,
    output zero
);

wire signed [31:0] signed_a = operand_a;
wire signed [31:0] signed_b = operand_b;
wire [4:0] shift = operand_b[4:0]; 

always @(*) begin
    case(alu_control)
        4'b0000: alu_result = operand_a + operand_b; //ADD
        4'b0001: alu_result = operand_a - operand_b; //SUB
        4'b0010: alu_result = operand_a & operand_b; //AND
        4'b0011: alu_result = operand_a | operand_b; //OR
        4'b0100: alu_result = operand_a ^ operand_b; //XOR
        4'b0101: alu_result = (signed_a < signed_b) ? 32'b1 : 32'b0; //SLT
        4'b0110: alu_result = (operand_a < operand_b) ? 32'b1 : 32'b0; //SLTU
        4'b0111: alu_result = operand_a << shift; //SLL
        4'b1000: alu_result = operand_a >> shift; //SRL
        4'b1001: alu_result = signed_a >>> shift; //SRA
        default: alu_result = 32'b0;
    endcase
end

assign zero = (alu_result == 32'b0);
    
endmodule