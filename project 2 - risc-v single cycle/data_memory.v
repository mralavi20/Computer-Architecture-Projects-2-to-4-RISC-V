module DataMemory (input clk, writeEn, [31:0] A, [31:0] WD, output [31:0] RD);

    reg [31:0] memory [0:(16000 - 1)];

    assign RD = memory [(A >> 2)];

    always @(posedge clk) begin
        if (writeEn)
            memory[(A>>2)] <= WD;
    end
endmodule