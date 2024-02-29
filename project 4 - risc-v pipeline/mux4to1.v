module mux4to1 (input [1:0] sel, [31:0] data1, [31:0] data2,[31:0] data3,[31:0] data4, output [31:0] outdata);
    assign outdata = (sel[1])? (sel[0]?data4:data3): (sel[0]?data2:data1);
endmodule

