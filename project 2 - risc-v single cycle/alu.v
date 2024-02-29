
module ALU (input [31:0] data1, [31:0] data2, [2:0] func, output zero, sign, [31:0] dataout);
    assign dataout = (func == 3'b000) ? data1 + data2:
                    (func == 3'b001) ? data1 - data2:
                    (func == 3'b010) ? data1 & data2:
                    (func == 3'b011) ? data1 | data2:
                    (func == 3'b100) ? data1 << data2:
                    (func == 3'b101)? ((data1 < data2)?32'b1:32'b0):
                    (func == 3'b110)? (data1 ^ data2):
                    32'b0;
    
    assign zero = (|dataout) ? 0 : 1;
    assign sign = (data1 >= data2) ? 0 : 1;
endmodule