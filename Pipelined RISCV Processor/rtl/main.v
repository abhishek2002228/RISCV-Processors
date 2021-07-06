
`include "ALU.v" 
`include "ALU_Control.v"
`include "control_unit.v"
`include "Data_Mem.v"
`include "Imm_Gen.v"
`include "Instr_Mem.v"
`include "reg_file.v"
`include "exmem.v"
`include "forwarding_unit.v"
`include "hazard_detection_unit.v"
`include "idex.v"
`include "ifid.v"
`include "memwb.v"
`include "PC.v"
module main(clk, rst, interrupt);
    input wire clk, rst, interrupt;

    wire pc_write, pc_src;//pc_write*
    wire [31:0] pc_next, pc_reg, mem_br_addr, pc_incr, instr;

    assign pc_incr = pc_reg + 4;
    assign pc_next = pc_src ? mem_br_addr : pc_incr;

    PC program_counter(clk, rst, pc_write, pc_next, pc_reg);
    Instr_Mem I_mem(pc_reg, instr);

    wire ifid_write;
    wire [31:0] id_pc, id_instr;

    ifid if_id(clk, rst, ifid_write, pc_reg, instr, id_pc, id_instr);

    wire [4:0] id_rs1, id_rs2, id_rd;
    wire [6:0] id_opcode, id_funct7;
    wire [2:0] id_funct3;

    assign id_rs1 = id_instr[19:15];
	assign id_rs2 = id_instr[24:20];
	assign id_rd = id_instr[11:7];
	assign id_opcode = id_instr[6:0];
	assign id_funct3 = id_instr[14:12];
	assign id_funct7 = id_instr[31:25];

    wire [3:0] id_ALU_Cntrl;
    wire [1:0] id_immsel, id_aluop;
    wire id_regwrite, id_alusrc, id_memread, id_memwrite, id_memtoreg, id_branch;
    wire wb_regwrite;
    wire [4:0] wb_rd;
    wire [31:0] wb_wr_data;
    wire [31:0] id_dat1, id_dat2, id_imm;

    control_unit cu(id_opcode, id_regwrite, id_immsel, id_alusrc, id_aluop, id_memread, id_memwrite, id_memtoreg, id_branch);
    ALU_Control_Unit alu_cu(id_aluop, id_funct3, id_funct7, id_ALU_Cntrl);
    reg_file regs(id_rs1, id_rs2, wb_rd, wb_wr_data, id_dat1, id_dat2, wb_regwrite, rst, clk);
    Imm_Gen immgen(id_instr, id_imm, id_immsel);

    wire cntrl;
    wire [13:0] id_control_sig_temp = {id_ALU_Cntrl, id_immsel, id_aluop, id_regwrite, id_alusrc, id_memread, id_memwrite, id_memtoreg, id_branch};
    wire [13:0] id_control_sig = cntrl ? id_control_sig_temp : 0;

    wire [13:0] ex_control_sig;
    wire [31:0] ex_pc, ex_imm, ex_dat1, ex_dat2;
    wire [4:0] ex_rs1, ex_rs2, ex_rd;

    idex id_ex(clk, rst, id_control_sig, id_pc, id_dat1, id_dat2, id_imm, id_rs1, id_rs2, id_rd,
 ex_control_sig, ex_pc, ex_dat1, ex_dat2, ex_imm, ex_rs1, ex_rs2, ex_rd);

    wire [1:0] forwardA, forwardB;
    
    reg [31:0] alu_in1, alu_in21;
    wire [31:0] alu_in2;

    always @(*)
    begin
        case(forwardA)
            2'b00: alu_in1 = ex_dat1;
            2'b01: alu_in1 = wb_wr_data;
            2'b10: alu_in1 = mem_alu[31:0];
            default: alu_in1 = ex_dat1;
        endcase
    end

    always @(*)
    begin
        case(forwardB)
            2'b00: alu_in21 = ex_dat2;
            2'b01: alu_in21 = wb_wr_data;
            2'b10: alu_in21 = mem_alu[31:0];
            default: alu_in21 = ex_dat2;
        endcase
    end

    assign alu_in2 = (ex_control_sig[4]) ? ex_imm : alu_in21;

    wire ex_zero;
    wire [31:0] ALU_Result;

    ALU alu(ex_control_sig[13:10], alu_in1, alu_in2, ex_zero, ALU_Result);

    wire [32:0] ex_alu = {ex_zero, ALU_Result};
    wire [31:0] ex_br_addr = (ex_pc) + (ex_imm << 1);
    
    wire [9:0] mem_control_sig;
    wire [31:0] mem_dat2;
    wire [32:0] mem_alu;
    wire [4:0] mem_rd; 


    exmem ex_mem(clk, rst, ex_control_sig[9:0], ex_br_addr, ex_alu, alu_in21, ex_rd, mem_control_sig, mem_br_addr, mem_alu, mem_dat2, mem_rd);

    assign pc_src = mem_alu[32] && mem_control_sig[0];

    wire [31:0] mem_memval;    
    Data_mem D_mem(mem_alu[31:0], mem_dat2, mem_memval, mem_control_sig[3], mem_control_sig[2], clk, rst);

    wire [9:0] wb_control_sig;
    wire [31:0] wb_memval, wb_alu;

    memwb mem_wb(clk, rst, mem_control_sig, mem_memval, mem_alu[31:0], mem_rd, wb_control_sig, wb_memval, wb_alu, wb_rd);

    assign wb_regwrite = wb_control_sig[5];
    assign wb_wr_data = (wb_control_sig[1]) ? wb_memval : wb_alu;

    forwarding_unit fw(mem_control_sig[5], mem_rd, wb_control_sig[5], wb_rd, ex_rs1, ex_rs2, forwardA, forwardB);
    hazard_det hd(ex_control_sig[3], id_rs1, id_rs2, ex_rd, pc_write, ifid_write, cntrl);
endmodule
