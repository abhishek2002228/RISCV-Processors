module IF_ID_PR(PC, instr, IF_ID_PC, IF_ID_instr, flush, clk, rst);
	input wire [31:0] PC, instr;
	output reg [31:0] IF_ID_PC, IF_ID_instr;
	input wire clk, rst, flush;
	
	
	always @(posedge rst, posedge clk)
		begin
		if(rst)
			begin
			IF_ID_PC <= 0;
			IF_ID_instr <= 0;
			end
		else
			begin
			if(flush)
				begin
				IF_ID_PC <= 0;
				IF_ID_instr <= 0;
				end
			else
				begin
				IF_ID_PC <= PC;
				IF_ID_instr <= instr;
				end
			end
		end
endmodule