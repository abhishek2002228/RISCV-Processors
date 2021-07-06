module memwb(clk, rst, mem_control_sig, mem_memval, mem_alu, mem_rd,
wb_control_sig, wb_memval, wb_alu, wb_rd);
    
    input wire clk, rst;
    input wire [9:0] mem_control_sig;
    output reg [9:0] wb_control_sig;
    input wire [31:0] mem_memval, mem_alu;
    output reg [31:0] wb_memval, wb_alu;
    input wire [4:0] mem_rd;
    output reg [4:0] wb_rd;

    always @(posedge clk, posedge rst)
    begin
        if(rst)
        begin
            wb_control_sig <= 0;
            wb_memval <= 0;
            wb_alu <= 0;
            wb_rd <= 0;
        end
        else
        begin
            wb_control_sig <= mem_control_sig;
            wb_memval <= mem_memval;
            wb_alu <= mem_alu;
            wb_rd <= mem_rd;
        end
    end
endmodule
    