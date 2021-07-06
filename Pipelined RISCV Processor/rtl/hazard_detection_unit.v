module hazard_det(memread, ifid_rs1, ifid_rs2, idex_rd, pc_write, ifid_write, cntrl);
    input wire memread;
    input wire [4:0] ifid_rs1, ifid_rs2, idex_rd;
    output wire pc_write, ifid_write, cntrl;

    wire stall;
    assign stall = (memread) && ((idex_rd == ifid_rs1) || (idex_rd == ifid_rs2));

    assign pc_write = ~stall;
    assign ifid_write = ~stall;
    assign cntrl = ~stall; // cntrl is 1 -> normal control signals
                           // cntrl is 0 -> 0 control signals 
endmodule