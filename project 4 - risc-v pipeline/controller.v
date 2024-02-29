

module controller(input [6:0] op, input [2:0] func3, input [6:0] func7, output reg reg_write, output reg [1:0] result_src, output reg mem_write, jump, branch,output reg [2:0] alucontrol,output reg alusrc, output reg [2:0] immsrc,output reg pc_src2, lui_signal_d);

always @(op,func3,func7)begin
    reg_write = 1'b0;
    result_src = 2'b00;
    mem_write = 1'b0;
    jump = 1'b0;
    branch =1'b0;
    alucontrol = 3'b000;
    alusrc = 1'b0;
    immsrc = 3'b000;
    pc_src2 = 1'b0;
    lui_signal_d = 1'b0;
    if (op == 7'd3)begin//lw
        mem_write = 1'b0;
        result_src = 2'b01;
        alusrc = 1'b1;
        immsrc = 3'b000;
        reg_write = 1'b1;
        alucontrol = 3'b000;
    end
    else if (op == 7'd35)begin//sw
        mem_write = 1'b1;
        alusrc = 1'b1;
        immsrc = 3'b001;
        reg_write = 1'b0;
        alucontrol = 3'b000;
    end
    else if (op == 7'd51)begin //R-type
        mem_write = 1'b0;
        result_src = 2'b00;
        alusrc = 1'b0;
        reg_write = 1'b1;        
        if (func3 == 3'b000 && func7[5] == 1'b0)//add
            alucontrol = 3'b000;

        else if(func3 == 3'b000 && func7[5] == 1'b1)//sub
            alucontrol = 3'b001;

        else if(func3 == 3'b111 && func7[5] == 1'b0)//and
            alucontrol = 3'b010;

        else if(func3 == 3'b110 && func7[5] == 1'b0)//or 
            alucontrol = 3'b011;
        
        else if(func3 == 3'b010 && func7[5] == 1'b0)//slt
            alucontrol = 3'b101;
    end
    else if (op == 7'd19)begin// addi ori xori ...
        reg_write = 1'b1;
        result_src = 2'b00;
        mem_write = 1'b0;
        if (func3 == 3'b000)//addi
            alucontrol = 3'b000;

        else if(func3 == 3'b100)//xori
            alucontrol = 3'b110;

        else if(func3 == 3'b110)//ori 
            alucontrol = 3'b011;
        
        else if(func3 == 3'b010)//slti
            alucontrol = 3'b101;    
        alusrc = 1'b1;
        immsrc = 3'b000;
    end
    else if (op == 7'd99) begin// b-type
        reg_write = 1'b0;
        mem_write = 1'b0;
        branch =1;
        alucontrol = 3'b001;
        alusrc = 1'b0;
        immsrc = 3'b010;
    end
    else if (op == 7'd103)begin//jalr
        reg_write = 1'b1;
        result_src = 2'b10;
        mem_write = 1'b0;
        jump = 0;
        branch =0;
        alucontrol = 3'b000;
        alusrc = 1'b1;
        immsrc = 3'b000;
        pc_src2 = 1'b1;
    end
    else if (op == 7'd111) begin//jal
        reg_write = 1'b1;
        result_src = 2'b10;
        mem_write = 1'b0;
        jump = 1'b1;
        branch =1'b0;
        immsrc = 3'b011;
    end
    else if (op == 7'd55) begin //lui
        reg_write = 1'b1;
        result_src = 2'b11;
        mem_write = 1'b0;
        immsrc = 3'b100;
        pc_src2 = 1'b0;
        lui_signal_d = 1'b1;
    end
end
endmodule
