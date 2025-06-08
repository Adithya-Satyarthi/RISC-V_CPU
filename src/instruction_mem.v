module instruction_mem (
    input [31:0] address,
    output [31:0] instruction
);
    
reg [31:0] memory[0:1023]; // Change later

//address is pointing to the index of each byte in the memory, to index words we divide by 4
assign instruction = memory[address[11:2]]; // 11-2+1 = 10 bit addressing

initial begin
    $readmemh("instruction.txt", memory);
end

endmodule