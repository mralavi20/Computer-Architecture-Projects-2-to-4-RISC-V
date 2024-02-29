module Register_1bit (input clk, rst, write_en ,input data_in, output data_out);
    reg data;

    always @(posedge clk,posedge rst, negedge write_en) begin
        if (rst)
            data <= 1'b0;
        else if (write_en == 1'b1)
            data <= data_in;
        else
            data <= data;
    end

    assign data_out = data;

endmodule
