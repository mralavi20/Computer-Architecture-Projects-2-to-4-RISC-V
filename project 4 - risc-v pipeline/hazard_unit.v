module hazard_unit (input clk,input pc_src_e,pc_src_e2,input [1:0] result_src_e, input  reg_write_m, reg_write_w, input [4:0] rs1_d, rs2_d, rs1_e, rs2_e, rd_e, rd_m, rd_w, output reg stall_f, stall_d, flush_d, flush_e, output reg [1:0] forward_a_e, forward_b_e);

always @(posedge clk)begin    
    stall_f = ((rs1_d == rd_e) || (rs2_d == rd_e)) && (result_src_e == 2'b01);
    stall_d = ((rs1_d == rd_e) || (rs2_d == rd_e)) && (result_src_e == 2'b01);
    flush_d = pc_src_e || pc_src_e2;
    flush_e = (((rs1_d == rd_e) || (rs2_d == rd_e)) && (result_src_e == 2'b01)) || pc_src_e || pc_src_e2;
end
always @(*)  begin 
    if (((rs1_e == rd_m) && reg_write_m) && rs1_e) begin
        forward_a_e = 2'b10;
    end
    else if (((rs1_e == rd_w) && reg_write_w) && rs1_e) begin
        forward_a_e = 2'b01;
    end
    else begin
        forward_a_e = 2'b00;
    end

    if (((rs2_e == rd_m) && reg_write_m) && rs2_e) begin
        forward_b_e = 2'b10;
    end
    else if (((rs2_e == rd_w) && reg_write_w) && rs2_e) begin
        forward_b_e = 2'b01;
    end
    else begin
        forward_b_e = 2'b00;
    end
end


endmodule