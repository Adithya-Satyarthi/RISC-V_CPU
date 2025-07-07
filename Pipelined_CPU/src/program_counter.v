module program_counter (
    input clk,
    input reset,
    input stallF,
    input [31:0] next_inst,
    output [31:0] curr_inst
);

reg [31:0] pc;
assign curr_inst = pc;

always @(posedge clk or posedge reset) begin
    if(reset) pc <= 32'b0;
    else if(!stallF) pc <= next_inst;
end
    
endmodule