module ID_stage(IF_ID_PC, IF_ID_instr, regwrite, immsel, alusrc, aluop, memread, memwrite, memtoreg, branch, stall, ID_EX_flush, MEM_WB_wr_reg, MEM_WB_regwrite, MEM_WB_wr_data, clk, rst, ID_EX_PC, ID_EX_rd_reg1, ID_EX_rd_reg2, ID_EX_wr_reg, ID_EX_DAT1, ID_EX_DAT2, ID_EX_imm, ID_EX_funct3, ID_EX_funct7, ID_EX_regwrite, ID_EX_alusrc, ID_EX_aluop, ID_EX_memread, ID_EX_memwrite, ID_EX_memtoreg, ID_EX_branch);
	
	input wire regwrite, alusrc, memread, memwrite, memtoreg, branch, stall, ID_EX_flush, clk, rst, , MEM_WB_regwrite;
	
	input wire [1:0] immsel, aluop;
	input wire [31:0] IF_ID_PC, IF_ID_instr, MEM_WB_wr_data;
	input wire [4:0] MEM_WB_wr_reg;
	
	output wire [31:0] ID_EX_PC, ID_EX_DAT1, ID_EX_DAT2, ID_EX_imm;
	output wire [4:0] ID_EX_rd_reg1, ID_EX_rd_reg2, ID_EX_wr_reg;
	output wire [2:0] ID_EX_funct3;
	output wire [6:0] ID_EX_funct7;
	output wire ID_EX_regwrite, ID_EX_alusrc, ID_EX_memread, ID_EX_memwrite, ID_EX_memtoreg, ID_EX_branch;
	output wire [1:0] ID_EX_aluop;
	
	wire regwrite_actual, alusrc_actual, memread_actual, memwrite_actual, memtoreg_actual, branch_actual;
	wire [1:0] aluop_actual;
	wire [4:0] rd_reg1, rd_reg2, IF_ID_wr_reg;
	wire [31:0] DAT1, DAT2, imm;
	wire [2:0] funct3;
	wire [6:0] funct7, opcode;
	
	assign rd_reg1 = IF_ID_instr[19:15];
	assign rd_reg2 = IF_ID_instr[24:20];
	assign IF_ID_wr_reg = IF_ID_instr[11:7];
	assign opcode = IF_ID_instr[6:0];
	assign funct3 = IF_ID_instr[14:12];
	assign funct7 = IF_ID_instr[31:25];
	assign cntrl = ~(ID_EX_flush || stall);
	
	assign {regwrite_actual, alusrc_actual, memread_actual, memwrite_actual, memtoreg_actual, branch_actual, aluop_actual} = (cntrl?) {regwrite, alusrc, memread, memwrite, memtoreg, branch, aluop} : 0 ;
	
	ID_EX_PR ID_EX(IF_ID_PC, rd_reg1, rd_reg2, IF_ID_wr_reg, DAT1, DAT2, imm, funct3, funct7, regwrite_actual, alusrc_actual, aluop_actual, memread_actual, memwrite_actual, memtoreg_actual, branch_actual, ID_EX_PC, ID_EX_rd_reg1, ID_EX_rd_reg2, ID_EX_wr_reg, ID_EX_DAT1, ID_EX_DAT2, ID_EX_imm, ID_EX_funct3, ID_EX_funct7, ID_EX_regwrite, ID_EX_alusrc, ID_EX_aluop, ID_EX_memread, ID_EX_memwrite, ID_EX_memtoreg, ID_EX_branch, clk, rst);
	
	reg_file regs(rd_reg1, rd_reg2, MEM_WB_wr_reg, MEM_WB_wr_data, DAT1, DAT2, MEM_WB_regwrite, rst, clk);
	Imm_Gen immgen(IF_ID_instr, imm, immsel);
endmodule 