
module controller(input clk,rst,zero,sign, input [6:0] op,input [2:0] func3, output reg mem_write, reg_write, pc_write, ir_write, wd_sel, output reg adr_src, output reg [1:0] alu_src_a, alu_src_b, output reg [1:0] aluop, output reg [1:0] result_src);
    parameter [0:3] IF=0, ID=1, EX_R=2, EX_S=3, EX_LW=4, EX_I = 5, EX_JAL=6, EX_JALR = 7, EX_B = 8,EX_LUI = 9, EX_LW_MEM = 10,EX_LW_REG = 11, EX_S_MEM = 12,EX_R_REG= 13,EX_I_REG = 14,EX_JALR_REG = 15;
    reg [0:3] ns,ps = 0; 
    always @(ps, op) begin
        ns = IF;
        case(ps)
        IF: ns = ID;
        ID: begin
            if(op == 7'd3)
                ns = EX_LW;
            else if(op == 7'd35)
                ns = EX_S;
            else if (op == 7'd51)
                ns = EX_R;
            else if (op == 7'd19)
                ns = EX_I;
            else if(op == 7'd99)
                ns = EX_B;
            else if(op == 7'd103)
                ns = EX_JALR;
            else if(op == 7'd111)
                ns = EX_JAL;
            else if(op == 7'd55)
                ns = EX_LUI;
        end
        //lw
        EX_LW: ns = EX_LW_MEM;
        EX_LW_MEM: ns = EX_LW_REG;
        EX_LW_REG: ns = IF;
        //sw
        EX_S: ns = EX_S_MEM;
        EX_S_MEM: ns = IF;
        //r-type
        EX_R: ns = EX_R_REG;
        EX_R_REG: ns = IF;
        //I-type
        EX_I: ns = EX_I_REG;
        EX_I_REG: ns= IF;
        //b-type
        EX_B: ns = IF;
        //jalr
        EX_JALR: ns = EX_JALR_REG;
        EX_JALR_REG: ns = IF;
        //jal
        EX_JAL: ns = IF;
        //lui
        EX_LUI: ns = IF;
		default: ns = IF;
        endcase
        end
    always @(ps,zero,sign, op) begin
        mem_write = 1'b0;
        reg_write = 1'b0;
        pc_write = 1'b0;
        ir_write = 1'b0;
        wd_sel = 1'b0;
        adr_src = 1'b0;
        alu_src_a = 2'b00;
        alu_src_b = 2'b00;
        aluop =  2'b00;
        result_src = 2'b00;
        case(ps)
        IF: begin
            mem_write = 1'b0;
            reg_write = 1'b0;
            pc_write = 1'b1;
            ir_write = 1'b1;
            wd_sel = 1'b0;
            adr_src = 1'b0;
            alu_src_a = 2'b00;
            alu_src_b = 2'b10;
            aluop =  2'b00;
            result_src = 2'b10;
        end
        ID: begin
            mem_write = 1'b0;
            reg_write = 1'b0;
            pc_write = 1'b0;
            ir_write = 1'b0;
            wd_sel = 1'b0;
            alu_src_a = 2'b01;
            alu_src_b = 2'b01;
            aluop =  2'b00;
            result_src = 2'b10;
        end
        EX_R: begin
            mem_write = 1'b0;
            reg_write = 1'b0;
            pc_write = 1'b0;
            ir_write = 1'b0;
            wd_sel = 1'b0;
            alu_src_a = 2'b10;
            alu_src_b = 2'b00;
            aluop =  2'b10;
        end

        EX_R_REG: begin
            mem_write = 1'b0;
            reg_write = 1'b1;
            pc_write = 1'b0;
            ir_write = 1'b0;
            wd_sel = 1'b0;
            result_src = 2'b00;
        end 
        EX_S: begin
            mem_write = 1'b0;
            reg_write = 1'b0;
            pc_write = 1'b0;
            ir_write = 1'b0;
            wd_sel = 1'b0;
            alu_src_a = 2'b10;
            alu_src_b = 2'b01;
            aluop =  2'b00;
        end
        EX_S_MEM: begin
            mem_write = 1'b1;
            reg_write = 1'b0;
            pc_write = 1'b0;
            ir_write = 1'b0;
            adr_src = 1'b1;
            result_src = 2'b00;
        end
        EX_LW: begin
            mem_write = 1'b0;
            reg_write = 1'b0;
            pc_write = 1'b0;
            ir_write = 1'b0;
            alu_src_a = 2'b10;
            alu_src_b = 2'b01;
            aluop =  2'b00;     
        end
        EX_LW_MEM: begin
            mem_write = 1'b0;
            reg_write = 1'b0;
            pc_write = 1'b0;
            ir_write = 1'b0;
            wd_sel = 1'b0;
            adr_src = 1'b1;
            result_src = 2'b00;        
        end
        EX_LW_REG: begin
            mem_write = 1'b0;
            reg_write = 1'b1;
            pc_write = 1'b0;
            ir_write = 1'b0;
            wd_sel = 1'b0;
            result_src = 2'b01;
        end
        EX_I: begin
            mem_write = 1'b0;
            reg_write = 1'b0;
            pc_write = 1'b0;
            ir_write = 1'b0;
            alu_src_a = 2'b10;
            alu_src_b = 2'b01;
            aluop =  2'b11;
        end
        EX_I_REG: begin
            mem_write = 1'b0;
            reg_write = 1'b1;
            pc_write = 1'b0;
            ir_write = 1'b0;
            wd_sel = 1'b0;
            result_src = 2'b00;
        end
        EX_B: begin
            mem_write = 1'b0;
            reg_write = 1'b0;
            if (func3 == 3'b000)
                pc_write = (zero)? 1'b1:1'b0;
            else if (func3 == 3'b001)
                pc_write = (zero)? 1'b0:1'b1;
            else if (func3 == 2'b100)
                pc_write = (sign)? 1'b1:1'b0;
            else if (func3 ==2'b101)
                pc_write = (zero)?1'b1:(sign?1'b0:1'b1);
            ir_write = 1'b0;
            alu_src_a = 2'b10;
            alu_src_b = 2'b00;
            aluop = 2'b01;
            result_src = 2'b00;
        end
        EX_JALR: begin
            mem_write = 1'b0;
            reg_write = 1'b0;
            pc_write = 1'b0;
            ir_write = 1'b0;
            alu_src_a = 2'b10;
            alu_src_b = 2'b01;
            aluop =  2'b00;
        end
        EX_JALR_REG: begin
            mem_write = 1'b0;
            reg_write = 1'b1;
            pc_write = 1'b1;
            wd_sel = 1'b1;
            result_src = 2'b00;
        end
        EX_JAL: begin
            mem_write = 1'b0;
            reg_write = 1'b1;
            pc_write = 1'b1;
            wd_sel = 1'b1;
            result_src = 2'b00;                
        end
        EX_LUI: begin
            mem_write = 1'b0;
            reg_write = 1'b1;
            pc_write = 1'b0;
            ir_write = 1'b0;
            wd_sel = 1'b0;
            result_src = 2'b11;
        end
        endcase
        end
    always@(posedge clk) begin
        if(rst == 1'b1)
            ps <= IF;
        else
            ps <= ns;
    end
endmodule
