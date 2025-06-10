module data_mem (
    input clk,
    input mem_write_en,
    input [31:0] address,
    input [31:0] write_data,
    output [31:0] read_data
);

reg [31:0] memory[0:1023];

assign read_data = memory[address[11:2]];

always @(posedge clk) begin
    if(mem_write_en) memory[address[11:2]] <= write_data;
end
    
endmodule