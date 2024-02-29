module mux4to1 (input [1:0] sel, input [31:0] data1, data2, data3, data4, output [31:0] outdata);
    assign outdata = (sel[1])? (sel[0]?data4:data3): (sel[0]?data2:data1);
endmodule

