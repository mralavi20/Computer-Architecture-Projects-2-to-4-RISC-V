module datapath(input clk,rst);

wire  pc_src_e, stal_f, stal_d, flush_d, reg_write_w, flush_e, alu_src_e, mem_write_m, pc_src2_d, pc_src2_e, zero_e, sign_e;
wire [31:0] pc_plus_4_f, pc_target_e, pc_f2, pc_f1, rd, instr_d, pc_d, pc_plus_4_d, rd1, rd2, result_w, ext_imm_d, rd1_e, rd2_e, pc_e, ext_imm_e, pc_plus_4_e, src_a_e, write_data_e, src_b_e, alu_result_m, alu_result, write_data_m, pc_plus_4_m, rd_m2, alu_result_w, read_data_w, pc_plus_4_w, ex_imm_m, ex_imm_w, alu_src_select;
wire [4:0] rd_w, rs1_e, rs2_e,rd_e,rd_m;
wire [2:0] imm_src_d, alu_control_e;
wire [1:0] forward_a_e, forward_b_e, result_src_w;

wire reg_write_d, mem_write_d, jump_d, branch_d, alu_src_d, reg_write_e, mem_write_e, jump_e, branch_e, lui_signal_d,lui_signal_e,lui_signal_m;
wire y;
wire [1:0] result_src_d, result_src_m,result_src_e;
wire [2:0] alu_control_d,instr_e;


assign y = branch_e && ((zero_e && (instr_e == 3'b000)) || (~zero_e && (instr_e== 3'b001)) || (sign_e && (instr_e== 3'b100)) || ((~sign_e | zero_e) &&(instr_e == 3'b101)));
assign pc_src_e = jump_e | y;


IM inst_memory (pc_f1, rd);
mux4to1 pc_mux ({pc_src2_e, pc_src_e}, pc_plus_4_f, pc_target_e, alu_result, alu_result, pc_f2);
Register pc_reg (clk, rst, ~stal_f, pc_f2, pc_f1);
adder pc_adder (pc_f1, 32'd4, pc_plus_4_f);
Register f_reg1 (clk, rst || flush_d, ~stal_d, rd, instr_d);
Register f_reg2 (clk, rst || flush_d, ~stal_d, pc_f1, pc_d);
Register f_reg3 (clk, rst || flush_d, ~stal_d, pc_plus_4_f,pc_plus_4_d);

RegisterFile reg_file (~clk, reg_write_w, instr_d[19:15], instr_d[24:20], rd_w, result_w, rd1, rd2);
Extend ext (instr_d[31:7], imm_src_d, ext_imm_d);
Register d_reg1 (clk, rst || flush_e, 1'b1, rd1, rd1_e);
Register d_reg2 (clk,rst || flush_e, 1'b1, rd2,rd2_e);
Register d_reg3 (clk, rst || flush_e, 1'b1, pc_d, pc_e);
Register_5bit d_reg4 (clk, rst || flush_e, 1'b1, instr_d[19:15], rs1_e);
Register_5bit d_reg5 (clk, rst || flush_e, 1'b1, instr_d[24:20], rs2_e);
Register_5bit d_reg6 (clk, rst || flush_e, 1'b1, instr_d[11:7], rd_e);
Register d_reg7 (clk, rst || flush_e, 1'b1, ext_imm_d, ext_imm_e);
Register d_reg8 (clk, rst || flush_e, 1'b1, pc_plus_4_d, pc_plus_4_e);


mux4to1 a_mux (forward_a_e, rd1_e, result_w, alu_src_select, 32'b0, src_a_e);
mux4to1 b_mux (forward_b_e, rd2_e, result_w, alu_src_select, 32'b0, write_data_e);
mux2to1 b2_mux (alu_src_e, write_data_e, ext_imm_e, src_b_e);
ALU alu (src_a_e, src_b_e, alu_control_e, zero_e, sign_e, alu_result);
adder pc_imm_adder(pc_e,ext_imm_e,pc_target_e);
Register e_reg1 (clk, rst, 1'b1, alu_result, alu_result_m);
Register e_reg2 (clk, rst, 1'b1, write_data_e, write_data_m);
Register_5bit e_reg3 (clk, rst, 1'b1, rd_e, rd_m);
Register e_reg4 (clk, rst, 1'b1, pc_plus_4_e, pc_plus_4_m);
Register e_reg5 (clk, rst, 1'b1, ext_imm_e, ex_imm_m);

DataMemory data_memory (clk, mem_write_m, alu_result_m, write_data_m, rd_m2);
mux2to1 alu_result_mux (lui_signal_m, alu_result_m, ex_imm_m, alu_src_select);
Register m_reg1 (clk, rst, 1'b1, alu_result_m, alu_result_w);
Register m_reg2 (clk, rst, 1'b1, rd_m2, read_data_w);
Register_5bit m_reg3 (clk, rst, 1'b1, rd_m, rd_w);
Register m_reg4 (clk, rst, 1'b1, pc_plus_4_m, pc_plus_4_w);
Register m_reg5 (clk, rst, 1'b1, ex_imm_m, ex_imm_w);

mux4to1 result_mux (result_src_w, alu_result_w, read_data_w, pc_plus_4_w, ex_imm_w, result_w);


Register_1bit c_d_reg1 (clk, rst || flush_e, 1'b1, reg_write_d, reg_write_e);
Register_2bit c_d_reg2 (clk, rst || flush_e, 1'b1, result_src_d, result_src_e);
Register_1bit c_d_reg3 (clk, rst || flush_e, 1'b1, mem_write_d, mem_write_e);
Register_1bit c_d_reg4 (clk, rst || flush_e, 1'b1, jump_d, jump_e);
Register_1bit c_d_reg5 (clk, rst || flush_e, 1'b1, branch_d, branch_e);
Register_3bit c_d_reg6 (clk, rst || flush_e, 1'b1, alu_control_d, alu_control_e);
Register_1bit c_d_reg7 (clk, rst || flush_e, 1'b1, alu_src_d, alu_src_e);
Register_1bit c_d_reg8 (clk, rst || flush_e, 1'b1, pc_src2_d, pc_src2_e);
Register_1bit c_d_reg9 (clk, rst || flush_e, 1'b1, lui_signal_d, lui_signal_e);
Register_3bit c_d_reg10 (clk, rst || flush_e, 1'b1, instr_d[14:12],instr_e);

Register_1bit c_e_reg1 (clk, rst, 1'b1, reg_write_e, reg_write_m);
Register_2bit c_e_reg2 (clk, rst, 1'b1, result_src_e, result_src_m);
Register_1bit c_e_reg3 (clk, rst, 1'b1, mem_write_e, mem_write_m);
Register_1bit c_e_reg4 (clk, rst, 1'b1, lui_signal_e, lui_signal_m);

Register_1bit c_m_reg1 (clk, rst, 1'b1, reg_write_m, reg_write_w);
Register_2bit c_m_reg2 (clk, rst, 1'b1, result_src_m, result_src_w);



controller controll(instr_d[6:0], instr_d[14:12],instr_d[31:25], reg_write_d, result_src_d, mem_write_d,jump_d,branch_d,alu_control_d,alu_src_d,imm_src_d,pc_src2_d,lui_signal_d);
hazard_unit hazardcontroll(clk,pc_src_e,pc_src2_e, result_src_e,reg_write_m,reg_write_w,instr_d[19:15],instr_d[24:20],rs1_e,rs2_e,rd_e,rd_m,rd_w,stal_f,stal_d,flush_d,flush_e,forward_a_e,forward_b_e);

endmodule




