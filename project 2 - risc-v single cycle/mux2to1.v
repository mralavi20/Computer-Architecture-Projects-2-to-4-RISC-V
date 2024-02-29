module mux2to1 (input sel, input [31:0] data1, data2, output [31:0] outdata);
    assign outdata = sel ? data2 : data1;
endmodule
