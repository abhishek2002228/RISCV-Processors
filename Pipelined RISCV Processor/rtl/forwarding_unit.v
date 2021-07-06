module forwarding_unit(exmem_regwr, exmem_rd, memwb_regwr, memwb_rd, idex_rs1, idex_rs2, forwardA, forwardB);
    input wire exmem_regwr, memwb_regwr;
    input wire [4:0] exmem_rd, memwb_rd, idex_rs1, idex_rs2;
    output reg [1:0] forwardA, forwardB;

    /*
    fwA/B: 00 -> from regfile
           01 -> from wb stage 
           10 -> from mem stage 

    */

    wire cond_exA = (exmem_regwr) && (|exmem_rd) && (exmem_rd == idex_rs1);
    wire cond_exB = (exmem_regwr) && (|exmem_rd) && (exmem_rd == idex_rs2);
    wire cond_memA = (memwb_regwr) && (|memwb_rd) && !cond_exA && (memwb_rd == idex_rs1);
    wire cond_memB = (memwb_regwr) && (|memwb_rd) && !cond_exB && (memwb_rd == idex_rs2);

    always @(*)
    begin
        forwardA = 2'b00;
        if(cond_exA)
            forwardA = 2'b10;
        else if(cond_memA)
            forwardA = 2'b01;
    end

    always @(*)
    begin
        forwardB = 2'b00;
        if(cond_exB)
            forwardB = 2'b10;
        else if(cond_memB)
            forwardB = 2'b01;
    end
endmodule