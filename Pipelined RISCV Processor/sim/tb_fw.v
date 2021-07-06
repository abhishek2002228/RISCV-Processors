module tb_fw();
    reg exmem_regwr, memwb_regwr;
    reg [4:0] exmem_rd, memwb_rd, idex_rs1, idex_rs2;
    wire [1:0] forwardA, forwardB;

    forwarding_unit fw(exmem_regwr, exmem_rd, memwb_regwr, memwb_rd, idex_rs1, idex_rs2, forwardA, forwardB);

    	initial
		begin
            exmem_regwr = 1'b1;
            memwb_regwr = 1'b0;
            exmem_rd = 4'h0;
            memwb_rd = 4'h1;
            idex_rs1 = 4'h0;
            idex_rs2 = 4'h1;

            #10

            exmem_regwr = 1'b1;
            memwb_regwr = 1'b0;
            exmem_rd = 4'h1;
            memwb_rd = 4'h2;
            idex_rs1 = 4'h1;
            idex_rs2 = 4'h0;

            #10
            
            exmem_regwr = 1'b1;
            memwb_regwr = 1'b1;
            exmem_rd = 4'h3;
            memwb_rd = 4'h3;
            idex_rs1 = 4'h3;
            idex_rs2 = 4'h1;

    		#40 $finish;
		end

        initial
		begin
            $dumpfile("fw.vcd");
            $dumpvars(0,tb_fw);
		end
endmodule