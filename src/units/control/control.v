module control( input [31:0] inst,
                input        brEq,
                input        brLT,
                output       pcSel,
                output [3:0] ImmSel,
                output       RegWEn,
                output       BrUn,
                output       BSel,
                output       ASel,
                output [3:0] ALUSel,
                output       sign,
                output       MemRW,
                output [1:0] WBSel
);

wire [31:0] w_instr_exe;

decode_ctl inst_decode_ctl(
    .clk(clk),
    .rst(rst),
    .instruction(inst),
    .immSel(ImmSel),
    .instr_exe(w_instr_exe)
);
    //Leaving this buffer module for more logic
    /*
    instr_ctl inst_instr_ctl(
        .instruction(inst), 
        .BrEq(brEq),
        .BrLT(brLT),
        .a_sel(ASel),
        .b_sel(BSel),
        .alu_sel(ALUSel),
        .sign(sign),
        .mem_wr(MemRW),
        .RegWEn(RegWEn),
        .immSel(ImmSel),
        .BrUn(BrUn),
        .pc_sel(pcSel),
        .wb_sel(WBSel)
    );
    */

endmodule
