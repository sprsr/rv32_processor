module rv32(
    input clk,
    input rst
);


wire        w_regWEn;
wire        w_pc_sel;
wire        w_a_sel;
wire        w_b_sel;
wire        w_sign;
wire        w_brEq;
wire        w_brLT;
wire        w_brUn;
wire        w_mem_rw;
wire  [3:0] w_alu_sel;
wire  [3:0] w_imm_sel;
wire  [1:0] w_wb_sel;
wire [31:0] w_pc_4;
wire [31:0] w_pc;
wire [31:0] w_instruction;
wire [31:0] w_immediate;
wire [31:0] w_wr_back;
wire [31:0] w_reg_data_A;
wire [31:0] w_reg_data_B;
wire [31:0] w_alu_in_A;
wire [31:0] w_alu_in_B;
wire [31:0] w_alu_out;
wire [31:0] w_dmem_out;
wire        w_alu_zero_flag;
wire [31:0] w_debug [31:0];

// Control will need to have clk and rst inputs to properly pipeline instructions
control inst_control(
    .clk(clk),
    .rst(rst),
    .inst(w_instruction),
    .brEq(w_brEq),
    .brLT(w_brLT),
    .pcSel(w_pc_sel),
    .ImmSel(w_imm_sel),
    .RegWEn(w_regWEn),
    .BrUn(w_BrUn),
    .BSel(w_b_sel),
    .ASel(w_a_sel),
    .ALUSel(w_alu_sel),
    .sign(w_sign),
    .MemRW(w_mem_rw),
    .WBSel(w_wb_sel)
);

PC inst_pc(
    .clk(clk),
    .rst(rst),
    .sel_pc(w_sel_pc),
    .in_pc(w_pc_4),
    .in_alu(w_alu_out),
    .pc_nxt(w_pc_4),
    .pc(w_pc)
);

imem inst_imem(
    .i_addr(w_pc),
    .o_data(w_instruction)
);

immGen inst_immGen(
    .immSel(w_imm_sel),
    .instr(w_instruction[31:7]),
    .immediate(w_immediate)
);

register inst_register(
    .clk(clk),
    .rst(rst),
    .regWEn(w_regWEn),
    .dataD(w_wr_back),
    .addrD(w_instruction[11:7]),
    .addrA(w_instruction[19:15]),
    .addrB(w_instruction[24:20]),
    .dataA(w_reg_data_A),
    .dataB(w_reg_data_B),
    .debug(w_debug)
);

branch_comp inst_branch_comp(
    .i_dataA(w_reg_data_A),
    .i_dataB(w_reg_data_B),
    .brUn(w_brUn),
    .brEq(w_brEq),
    .brLT(w_brLT)
);

mux2x1 inst_mux2x1_A(
    .a(w_pc),
    .b(w_reg_data_A),
    .sel(w_a_sel),
    .y(w_alu_in_A)
);

mux2x1 inst_mux2x1_B(
    .a(w_immediate),
    .b(w_reg_data_B),
    .sel(w_b_sel),
    .y(w_alu_in_B)
);

alu inst_alu(
    .i_1(w_alu_in_A),
    .i_2(w_alu_in_B),
    .aluSel(w_alu_sel),
    .sign(w_sign),
    .result(w_alu_out),
    .zero_flag(w_alu_zero_flag)
);

dmem inst_dmem(
    .clk(clk),
    .rst(rst),
    .i_addr(w_alu_out),
    .dataW(w_reg_data_B),
    .memRW(w_mem_rw),
    .o_data(w_dmem_out)
);

mux3x1 inst_mux3x1_wb(
    .a(w_pc_4),
    .b(w_alu_out),
    .c(w_dmem_out),
    .sel(w_wb_sel),
    .y(w_wr_back)
);

debug_port inst_debug(
    .registers(w_debug),
    .reg0(w_debug[0]),
    .reg1(w_debug[1]),
    .reg2(w_debug[2]),
    .reg3(w_debug[3]),
    .reg4(w_debug[4]),
    .reg5(w_debug[5]),
    .reg6(w_debug[6]),
    .reg7(w_debug[7]),
    .reg8(w_debug[8]),
    .reg9(w_debug[9]),
    .reg10(w_debug[10]),
    .reg11(w_debug[11]),
    .reg12(w_debug[12]),
    .reg13(w_debug[13]),
    .reg14(w_debug[14]),
    .reg15(w_debug[15]),
    .reg16(w_debug[16]),
    .reg17(w_debug[17]),
    .reg18(w_debug[18]),
    .reg19(w_debug[19]),
    .reg20(w_debug[20]),
    .reg21(w_debug[21]),
    .reg22(w_debug[22]),
    .reg23(w_debug[23]),
    .reg24(w_debug[24]),
    .reg25(w_debug[25]),
    .reg26(w_debug[26]),
    .reg27(w_debug[27]),
    .reg28(w_debug[28]),
    .reg29(w_debug[29]),
    .reg30(w_debug[30]),
    .reg31(w_debug[31])
);
endmodule
