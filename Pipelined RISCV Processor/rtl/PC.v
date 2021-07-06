module PC(clk, rst, enable, PC_next, PC_reg);
    input wire clk, rst, enable;
    input wire [31:0] PC_next;
    output reg [31:0] PC_reg;

    always @(posedge clk, posedge rst)
    begin
        if(rst)
            PC_reg <= 0;
        else if(enable) 
            PC_reg <= PC_next;
    end
endmodule