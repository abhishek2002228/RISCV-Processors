module IF_stage(PCWrite, IF_ID_Write, br_target, pcsrc, IF_ID_flush, IF_ID_PC, IF_ID_instr, clk, rst);

	input wire clk, rst, pcsrc, IF_ID_flush, PCWrite, IF_ID_Write;
	input wire [31:0] br_target;
	output wire [31:0] IF_ID_PC, IF_ID_instr;

	reg [31:0] PC_reg;
	wire [31:0] PC_next, PC_incr;
	wire [31:0] instr;
	wire gated_clock_IF_ID, gated_clock_PC;

	assign gated_clock_IF_ID = clk & IF_ID_Write;
	assign gated_clock_PC = clk & PCWrite;

	assign PC_next = (pcsrc) ? br_target: PC_incr;
	assign PC_incr = PC_reg + 4;

	Instr_Mem I_mem(PC_reg,instr);
	IF_ID_PR IF_ID(PC_reg, instr, IF_ID_PC, IF_ID_instr, IF_ID_flush, gated_clock_IF_ID, rst); 

	always @(posedge gated_clock_PC, posedge rst)
		begin
			if(rst)
				PC_reg <= 0;
			else
				PC_reg <= PC_next;
		end
endmodule