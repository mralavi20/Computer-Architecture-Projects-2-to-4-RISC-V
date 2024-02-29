

module DataMemory (input clk, writeEn, [31:0] A, [31:0] WD, output [31:0] RD);

    reg [31:0] data_mem [0:(16000 - 1)];
    initial begin
        $readmemh ("data.txt ", data_mem);
    end


    assign RD = data_mem [(A >> 2)];

    always @(posedge clk) begin
        if (writeEn)
            data_mem[(A>>2)] <= WD;
    end
endmodule