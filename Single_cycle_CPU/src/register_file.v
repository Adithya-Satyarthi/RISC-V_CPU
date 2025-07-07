module register_file (
    input clk,
    input [4:0] read_index_a,
    input [4:0] read_index_b,
    input [4:0] write_index,
    input [31:0] reg_write,
    input reg_write_en,
    output [31:0] data_a,
    output [31:0] data_b
);

reg [31:0] registers[0:31];

assign data_a = (read_index_a == 5'b0) ? 32'b0 : registers[read_index_a];

assign data_b = (read_index_b == 5'b0) ? 32'b0 : registers[read_index_b];

always @(posedge clk) begin
    if(reg_write_en && write_index != 32'b0) begin
        registers[write_index] <= reg_write;
    end
end
    
endmodule