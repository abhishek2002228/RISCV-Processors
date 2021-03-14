module Fwding_Unit(EX_MEM_wr_reg, EX_MEM_regwrite, ID_EX_rd_reg1, ID_EX_rd_reg2, MEM_WB_regwrite, MEM_WB_wr_reg, fwdRs1, fwdRs2, clk, rst);

	input wire EX_MEM_regwrite, MEM_WB_regwrite, clk, rst;
	input wire [4:0] EX_MEM_wr_reg, ID_EX_rd_reg1, ID_EX_rd_reg2, MEM_WB_wr_reg;
	output wire [1:0] fwdRs1, fwdRs2;
	
	wire ExA, ExB, MemA, MemB;
	
	assign ExA = (EX_MEM_regwrite&(EX_MEM_wr_reg != 0)&(EX_MEM_wr_reg=ID_EX_rd_reg1));
	
	assign ExB = (EX_MEM_regwrite&(EX_MEM_wr_reg != 0)&(EX_MEM_wr_reg=ID_EX_rd_reg2));
	
	assign MemA = (MEM_WB_regwrite&(MEM_WB_wr_reg != 0)&(MEM_WB_wr_reg=ID_EX_rd_reg1)&(!ExA));

	assign MemB = (MEM_WB_regwrite&(MEM_WB_wr_reg != 0)&(MEM_WB_wr_reg=ID_EX_rd_reg2)&(!ExB));

	assign fwdRs1 = ExA? 2'b01 : MemA? 2'b10 : 2'b00 ;
	assign fwdRs2 = ExB? 2'b01 : MemB? 2'b10 : 2'b00 ;
endmodule