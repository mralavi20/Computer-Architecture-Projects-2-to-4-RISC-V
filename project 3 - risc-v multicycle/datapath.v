


module datapath(input clk,rst, mem_write, reg_write, pc_write, ir_write, wd_sel, adr_src, input [1:0] alu_src_a, input [1:0] alu_src_b, input [2:0] alu_control, input [1:0] result_src, output zero, sign,output [6:0]op_out,output [2:0] func3, output [6:0] func7);

wire [31:0] pc_out, adr, read_data, old_pc, instr, data, rd1, rd2, data_a, data_b, imm_ext, src_a, src_b, alu_result, alu_out, result, wd;

Register pc_reg (clk, rst, pc_write, result, pc_out);
mux2to1 adr_mux (adr_src, pc_out, result, adr);
DataMemory data_memory (clk, mem_write, adr, data_b, read_data);
Register instr_reg (clk, rst, ir_write, read_data, instr);
Register old_pc_reg (clk, rst, ir_write, pc_out, old_pc);
Register data_reg (clk, rst, 1'b1, read_data, data);
RegisterFile reg_file (clk, reg_write, instr[19:15], instr[24:20], instr[11:7], wd, rd1, rd2);
mux2to1 wd_mux (wd_sel, result, pc_out, wd);
Register rd1_reg (clk, rst, 1'b1, rd1, data_a);
Register rd2_reg (clk, rst, 1'b1, rd2, data_b);
Extend ext (instr[31:7], instr[6:0], imm_ext);
mux4to1 mux_a (alu_src_a, pc_out, old_pc, data_a, 32'b0, src_a);
mux4to1 mux_b (alu_src_b, data_b, imm_ext, 32'd4, 32'b0, src_b);
ALU alu (src_a, src_b, alu_control, zero, sign, alu_result);
Register alu_out_reg  (clk, rst, 1'b1, alu_result, alu_out);
mux4to1 result_mux (result_src, alu_out, data, alu_result, imm_ext, result);
assign op_out = instr[6:0];
assign func3 = instr[14:12];
assign func7 = instr[31:25];

endmodule

