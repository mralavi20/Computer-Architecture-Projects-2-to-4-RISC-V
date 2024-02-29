module PC (input clk, rst, input [31:0] data_in, output [31:0] data_out);
    reg [31:0] data;

    always @(posedge clk, posedge rst) begin
        if (rst)
            data <= 32'b0;
        else
            data <= data_in;
    end

    assign data_out = data;

endmodule