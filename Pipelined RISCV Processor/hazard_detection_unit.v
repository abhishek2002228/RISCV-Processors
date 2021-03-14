module hazard_detection_unit(ID_EX_memread, IF_ID_instr, ID_EX_wr_reg, stall);

	input wire ID_EX_memread, clk, rst;
	input wire [31:0] IF_ID_instr;
	input wire [4:0] ID_EX_wr_reg;
	output wire stall;
	
	wire [4:0] IF_ID_rd_reg1, IF_ID_rd_reg2;
	
	assign IF_ID_rd_reg1 = IF_ID_instr[19:15];
	assign IF_ID_rd_reg2 = IF_ID_instr[24:20];
	
	assign stall = (ID_EX_memread)&((ID_EX_wr_reg==IF_ID_rd_reg1)||(ID_EX_wr_reg==IF_ID_rd_reg2));
	
endmodule