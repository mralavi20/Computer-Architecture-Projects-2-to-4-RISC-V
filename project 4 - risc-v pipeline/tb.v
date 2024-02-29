

`timescale 1ns/1ns




module tb();

reg clk, rst;

datapath proccesor(clk,rst);

initial begin
    rst = 0;
    clk = 0;
    #100 rst = 1;
    #120 rst = 0;
end

initial begin
    repeat(100) #15 clk = ~clk;
end



endmodule

