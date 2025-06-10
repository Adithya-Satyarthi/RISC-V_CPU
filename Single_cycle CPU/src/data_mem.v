module data_mem (
    input clk,
    input mem_read_en,
    input mem_write_en,
    input [31:0] address,
    input [31:0] write_data,
    output reg [31:0] read_data
);

reg [31:0] memory[0:1023];

always @(*) begin
    if(mem_read_en) read_data = memory[address[11:2]]; //Read Asyncronously
    else read_data = 32'b0;
end

always @(posedge clk) begin
    if(mem_write_en) memory[address[11:2]] <= write_data;
end
    
endmodule