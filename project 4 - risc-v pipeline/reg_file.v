module RegisterFile (input clk, we3, [4:0] A1, [4:0] A2, [4:0] A3, [31:0] WD3, output [31:0] RD1, [31:0] RD2);
    reg [31:0] registers [0:31];

    assign registers[0] = 32'b0;
    assign RD1 = registers[A1];
    assign RD2 = registers[A2];

    always @(posedge clk) begin
        if (we3 == 1'b1) begin
            if (A3 != 5'b0)
                registers[A3] <= WD3;
        end
    end
endmodule