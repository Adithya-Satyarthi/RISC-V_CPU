module hazard_unit (
    input [4:0] RS1D,
    input [4:0] RS2D,
    input [4:0] RS1E,
    input [4:0] RS2E,
    input [4:0] rdE,
    input pc_srcE,
    input result_srcE0,
    input [4:0] rdM,
    input reg_write_enM,
    input [4:0] rdW,
    input reg_write_enW,
    output reg [1:0] forwardAE,
    output reg [1:0] forwardBE,
    output forwardAD,
    output forwardBD,
    output flushE,
    output flushD,
    output stallD,
    output stallF
);

always @(*) begin
    //ForwardAE
    if(((RS1E == rdM) && reg_write_enM) && (RS1E != 5'b0))
        forwardAE = 2'b10;
    else if(((RS1E == rdW) && reg_write_enW) && (RS1E != 5'b0))
        forwardAE = 2'b01;
    else forwardAE = 2'b00;

    //ForwardBE
    if(((RS2E == rdM) && reg_write_enM) && (RS2E != 5'b0))
        forwardBE = 2'b10;
    else if(((RS2E == rdW) && reg_write_enW) && (RS2E != 5'b0))
        forwardBE = 2'b01;
    else forwardBE = 2'b00;
end

assign forwardAD = (reg_write_enW && (rdW != 5'b0) && (rdW == RS1D));
assign forwardBD = (reg_write_enW && (rdW != 5'b0) && (rdW == RS2D));

wire lwstall;
assign lwstall = ((RS1D == rdE) || (RS2D == rdE)) && result_srcE0;

assign stallD = lwstall;
assign stallF = lwstall;

assign flushD = pc_srcE;
assign flushE = lwstall || pc_srcE;

endmodule