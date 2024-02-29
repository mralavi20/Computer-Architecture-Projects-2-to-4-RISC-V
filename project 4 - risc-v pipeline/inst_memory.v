module IM(input [31:0] A, output reg[31:0] RD);

    reg [31:0] memory [0:(16000 - 1)];
    initial begin
        $readmemh ("Mem.txt ", memory);
    end

    always @(*)begin
        RD = memory[(A >> 2)];
    end

endmodule