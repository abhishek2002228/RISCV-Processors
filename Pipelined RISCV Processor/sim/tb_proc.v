module tb_proc();
	reg clk, rst, interrupt;
	
	main A(clk, rst, interrupt);
	
	always #5 clk = ~clk;
	
	initial
		begin
		$monitor($time," r0=%d, r1=%d, r3=%d r4=%d mem16=%d mem17=%d",A.regs.reg_num[0],A.regs.reg_num[1],A.regs.reg_num[3],A.regs.reg_num[4],A.D_mem.d_mem[16], A.D_mem.d_mem[17]);
		rst = 1'b1;
		clk = 1'b0;
		interrupt = 1'b0;
		#1
		rst = 1'b0;
		repeat(10) @(negedge clk);
		$finish;
		end
	
	initial
		begin
		$dumpfile("proc.vcd");
		$dumpvars(0,tb_proc);
		end
endmodule 
