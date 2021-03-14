module ID_EX_PR(PC, rd_reg1, rd_reg2, wr_reg, DAT1, DAT2, imm, funct3, funct7, regwrite, alusrc, aluop, memread, memwrite, memtoreg, branch, ID_EX_PC, ID_EX_rd_reg1, ID_EX_rd_reg2, ID_EX_wr_reg, ID_EX_DAT1, ID_EX_DAT2, ID_EX_imm, ID_EX_funct3, ID_EX_funct7, ID_EX_regwrite, ID_EX_alusrc, ID_EX_aluop, ID_EX_memread, ID_EX_memwrite, ID_EX_memtoreg, ID_EX_branch, clk, rst);

	
	input wire [31:0] PC, DAT1, DAT2, imm ;
	input wire [4:0] rd_reg1, rd_reg2, wr_reg;
	input wire [2:0] funct3;
	input wire [6:0] funct7;
	input wire regwrite, alusrc, memread, memwrite, memtoreg, branch;
	input wire [1:0] aluop;
	
	output wire [31:0] ID_EX_PC, ID_EX_DAT1, ID_EX_DAT2, ID_EX_imm;
	output wire [4:0] ID_EX_rd_reg1, ID_EX_rd_reg2, ID_EX_wr_reg;
	output wire [2:0] ID_EX_funct3;
	output wire [6:0] ID_EX_funct7;
	output wire ID_EX_regwrite, ID_EX_alusrc, ID_EX_memread, ID_EX_memwrite, ID_EX_memtoreg, ID_EX_branch;
	output wire [1:0] ID_EX_aluop;
	
	
	always @(posedge clk, posedge rst)
		begin
		if(rst)
			begin
			{ID_EX_PC, ID_EX_rd_reg1, ID_EX_rd_reg2, ID_EX_wr_reg, ID_EX_DAT1, ID_EX_DAT2, ID_EX_imm, ID_EX_funct3, ID_EX_funct7, ID_EX_regwrite, ID_EX_alusrc, ID_EX_aluop, ID_EX_memread, ID_EX_memwrite, ID_EX_memtoreg, ID_EX_branch} <= 0;
			end
		else
			begin
			{ID_EX_PC, ID_EX_rd_reg1, ID_EX_rd_reg2, ID_EX_wr_reg, ID_EX_DAT1, ID_EX_DAT2, ID_EX_imm, ID_EX_funct3, ID_EX_funct7, ID_EX_regwrite, ID_EX_alusrc, ID_EX_aluop, ID_EX_memread, ID_EX_memwrite, ID_EX_memtoreg, ID_EX_branch} <= {PC, rd_reg1, rd_reg2, wr_reg, DAT1, DAT2, imm, funct3, funct7, regwrite, alusrc, aluop, memread, memwrite, memtoreg, branch};
			end
		end
		
endmodule