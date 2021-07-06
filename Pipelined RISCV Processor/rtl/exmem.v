module exmem(clk, rst, ex_control_sig, ex_pc, ex_alu, ex_dat2, ex_rd,
mem_control_sig, mem_pc, mem_alu, mem_dat2, mem_rd);

    input wire clk, rst;
    input wire [9:0] ex_control_sig;
    output reg [9:0] mem_control_sig;
    input wire [31:0] ex_pc, ex_dat2;
    output reg [31:0] mem_pc, mem_dat2;
    input wire [32:0] ex_alu;
    output reg [32:0] mem_alu;
    input wire [4:0] ex_rd;
    output reg [4:0] mem_rd;

    always @(posedge clk, posedge rst)
    begin
        if(rst)
        begin
            mem_control_sig <= 0;
            mem_pc <= 0;
            mem_dat2 <= 0;
            mem_alu <= 0;
            mem_rd <= 0;
        end
        else
        begin
            mem_control_sig <= ex_control_sig;
            mem_pc <= ex_pc;
            mem_dat2 <= ex_dat2;
            mem_alu <= ex_alu;
            mem_rd <= ex_rd;
        end
    end
endmodule