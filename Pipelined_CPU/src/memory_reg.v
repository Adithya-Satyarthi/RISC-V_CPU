module memory_reg (
    input clk,
    input reset,
    input reg_write_enE,
    input [1:0] result_srcE,
    input mem_write_enE,
    input [31:0] alu_resultE,
    input [31:0] write_dataE,
    input [4:0] rdE,
    input [31:0] pc_plus_4E,
    output reg reg_write_enM,
    output reg [1:0] result_srcM,
    output reg mem_write_enM,
    output reg [31:0] alu_resultM,
    output reg [31:0] write_dataM,
    output reg [4:0] rdM,
    output reg [31:0] pc_plus_4M
);

always @(posedge clk) begin
    if(reset) begin
        reg_write_enM <= 1'b0;
        result_srcM <= 2'b0;
        mem_write_enM <= 1'b0;
        alu_resultM <= 32'b0;
        write_dataM <= 32'b0;
        rdM <= 5'b0;
        pc_plus_4M <= 32'b0;  
    end
    else begin
        reg_write_enM <= reg_write_enE;
        result_srcM <= result_srcE;
        mem_write_enM <= mem_write_enE;
        alu_resultM <= alu_resultE;
        write_dataM <= write_dataE;
        rdM <= rdE;
        pc_plus_4M <= pc_plus_4E;
    end

end

endmodule