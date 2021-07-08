module ifid(flush, clk, rst, enable, if_pc, if_instr, id_pc, id_instr);
    input wire clk, rst, enable, flush;
    input wire [31:0] if_pc, if_instr;
    output reg [31:0] id_pc, id_instr;

    always @(posedge clk, posedge rst)
    begin
        if(rst || flush)
        begin
            id_pc <= 0;
            id_instr <= 0;
        end
        else if(enable)
        begin
            id_pc <= if_pc;
            id_instr <= if_instr;          
        end
    end
endmodule