module instr_ctl(
    input [31:0] instruction,
    input        BrEq,
    input        BrLT,
    output       a_sel,
    output       b_sel,
    output       alu_sel,
    output       mem_wr,
    output       RegWEn,
    output [3:0] immSel,
    output       BrUn,
    output       pc_sel,
    output [1:0] wb_sel
);

reg       r_a_sel;
reg       r_b_sel;
reg [3:0] r_alu_sel;
reg       r_mem_wr;
reg       r_RegWEn;
reg [3:0] r_immSel;
reg       r_BrUn;
reg       r_pc_sel;
reg [1:0] r_wb_sel;

assign a_sel   = r_a_sel;
assign b_sel   = r_b_sel;
assign alu_sel = r_alu_sel;
assign mem_wr  = r_mem_wr;
assign RegWEn  = r_RegWEn;
assign immSel  = r_immSel;
assign BrUn    = r_BrUn;
assign pc_sel  = r_pc_sel;
assign wb_sel  = r_wb_sel;

always @(*) begin
    case (instruction[6:0])
        // LUI Instruction: 
        7'b0110111: begin
            r_a_sel   <= 1'b0;
            r_b_sel   <= 1'b1;
            r_alu_sel <= 4'b1001;
            r_mem_wr  <= 1'b0;
            r_RegWEn  <= 1'b1;
            r_immSel  <= 4'h4;
            r_BrUn    <= 1'bx;
            r_pc_sel  <= 1'b0;
            r_wb_sel  <= 2'b01;
        end
        // AUIPC Instruction: 
        7'b0010111: begin
            r_a_sel   <= 1'b1;
            r_b_sel   <= 1'b1;
            r_alu_sel <= 4'b0010;
            r_mem_wr  <= 1'b0;
            r_RegWEn  <= 1'b1;
            r_immSel  <= 4'h4;
            r_BrUn    <= 1'bx;
            r_pc_sel  <= 1'b0;
            r_wb_sel  <= 2'b01;
        end
        // JAL Instruction:
        7'b1101111: begin
            r_a_sel   <= 1'b1;
            r_b_sel   <= 1'b1;
            r_alu_sel <= 4'b0010;
            r_mem_wr  <= 1'b0;
            r_RegWEn  <= 1'b1;
            r_immSel  <= 4'h5;
            r_BrUn    <= 1'bx; 
            r_pc_sel  <= 1'b1;
            r_wb_sel  <= 2'b10;
        end
        // JALR Instruction:
        7'b1101111: begin
            r_a_sel   <= 1'b0;
            r_b_sel   <= 1'b1;
            r_alu_sel <= 4'b0010;
            r_mem_wr  <= 1'b0;
            r_RegWEn  <= 1'b1;
            r_immSel  <= 4'h1;
            r_BrUn    <= 1'bx; 
            r_pc_sel  <= 1'b1;
            r_wb_sel  <= 2'b10;
        end
        7'b1100011: begin
            case (instruction[14:12])
                // BEQ Instruction:
                3'b000: begin
                    r_a_sel   <= 1'b0;
                    r_b_sel   <= 1'b0;
                    r_alu_sel <= 4'b0010;
                    r_mem_wr  <= 1'b0;
                    r_RegWEn  <= 1'b0;
                    r_immSel  <= 4'h3;
                    r_BrUn    <= 1'bx; 
                    case (BrEq)
                        1'b0: r_pc_sel <= 1'b0;
                        1'b1: r_pc_sel <= 1'b1;
                    endcase
                    r_wb_sel  <= 2'bx;
                end
                // BNE Instruction
                3'b001: begin
                    r_a_sel   <= 1'b0;
                    r_b_sel   <= 1'b0;
                    r_alu_sel <= 4'b0010;
                    r_mem_wr  <= 1'b0;
                    r_RegWEn  <= 1'b0;
                    r_immSel  <= 4'h3;
                    r_BrUn    <= 1'bx; 
                    case (BrEq)
                        1'b0: r_pc_sel <= 1'b0;
                        1'b1: r_pc_sel <= 1'b1;
                    endcase
                    r_wb_sel  <= 2'bx;

                end
            
    endcase
end
endmodule