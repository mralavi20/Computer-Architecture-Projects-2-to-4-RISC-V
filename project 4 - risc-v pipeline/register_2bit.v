module Register_2bit (input clk, rst, write_en ,input [1:0] data_in, output [1:0] data_out);
    reg [1:0] data;
    always @(posedge clk,posedge rst,negedge write_en) begin
        if (rst)
            data <= 2'b0;
        else if (write_en == 1'b1)
            data <= data_in;
        else
            data <= data;
    end

    assign data_out = data;

endmodule
