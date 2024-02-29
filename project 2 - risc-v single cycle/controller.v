

module MainController(input [6:0] op,output reg MemWrite,output reg [1:0] ResultSrc,output reg ALUSrc,output reg [2:0] ImmSrc, output reg RegWrite,output reg [2:0] ALUop);

always @(*)begin
    MemWrite = 1'b0;
    ResultSrc = 2'b00;
    ALUSrc = 1'b0;
    ImmSrc = 3'b000;
    RegWrite = 1'b0;
    ALUop = 3'b000;
    if (op == 7'd3)begin//lw
        MemWrite = 1'b0;
        ResultSrc = 2'b01;
        ALUSrc = 1'b1;
        ImmSrc = 3'b000;
        RegWrite = 1'b1;
        ALUop = 3'b000;
    end
    else if (op == 7'd35)begin//sw
        MemWrite =1'b1;
        ALUSrc = 1'b1;
        ImmSrc = 3'b001;
        RegWrite = 1'b0;
        ALUop = 3'b000;
    end
    else if (op == 7'd51)begin //R-type
        MemWrite = 1'b0;
        ResultSrc = 2'b00;
        ALUSrc = 1'b0;
        RegWrite = 1'b1;
        ALUop = 3'b010;
    end
    else if (op == 7'd19)begin// addi ori xori ...
        MemWrite = 1'b0;
        ResultSrc = 2'b00;
        ALUSrc = 1'b1;
        ImmSrc = 3'b000;
        RegWrite = 1'b1;
        ALUop = 3'b101;
    end
    else if (op == 7'd99) begin// b-type
        MemWrite = 1'b0;
        ResultSrc = 2'b10;
        ALUSrc = 1'b0;
        ImmSrc = 3'b010;
        RegWrite = 1'b0;
        ALUop = 3'b001;
        
    end
    else if (op == 7'd103)begin//jalr
        MemWrite = 1'b0;
        ResultSrc = 2'b10;
        ALUSrc = 1'b1;
        ImmSrc = 3'b000;
        RegWrite = 1'b1;
        ALUop = 3'b100;
    end
    else if (op == 7'd111) begin//jal
        MemWrite = 1'b0;
        ResultSrc = 2'b10;
        ImmSrc = 3'b011;
        RegWrite = 1'b1;
        ALUop = 3'b011;
    end
    else if (op == 7'd55) begin //lui
        MemWrite = 1'b0;
        ResultSrc = 2'b11;
        ImmSrc = 3'b100;
        RegWrite = 1'b1;
        ALUop = 3'b000;  
    end
end
endmodule

module ALUController(input sign,zero,input [2:0] ALUOp, input [2:0] func3, input [6:0] func7, output reg [1:0] PCSrc, output reg [2:0] ALUControl);

always @(*)begin
    PCSrc = 2'b00;
    ALUControl = 3'b000;
    if (ALUOp == 3'b000) begin //lw sw lui
        ALUControl = 3'b000;
        PCSrc = 2'b00;
    end
    else if (ALUOp == 3'b001)begin//b-type
        ALUControl = 3'b001;
        if (func3 == 3'b000)//beq
            PCSrc = zero? 2'b01: 2'b00;

        else if (func3 == 3'b001)//bne
            PCSrc = zero? 2'b00: 2'b01;

        else if (func3 == 3'b100)//blt
            PCSrc = sign? 2'b01:2'b00;
        
        else if (func3 == 3'b101)//bge
            PCSrc = (zero)?2'b01:(sign?2'b00:2'b01);
    end
    else if (ALUOp == 3'b010) begin//r-type
        PCSrc = 2'b00;
        if (func3 == 3'b000 && func7[5] == 1'b0)//add
            ALUControl = 3'b000;

        else if(func3 == 3'b000 && func7[5] == 1'b1)//sub
            ALUControl = 3'b001;

        else if(func3 == 3'b111 && func7[5] == 1'b0)//and
            ALUControl = 3'b010;

        else if(func3 == 3'b110 && func7[5] == 1'b0)//or 
            ALUControl = 3'b011;
        
        else if(func3 == 3'b010 && func7[5] == 1'b0)//slt
            ALUControl = 3'b101;
    end
    else if (ALUOp == 3'b101) begin //i-type
        PCSrc = 2'b00;
        if (func3 == 3'b000)//addi
            ALUControl = 3'b000;

        else if(func3 == 3'b100)//xori
            ALUControl = 3'b110;

        else if(func3 == 3'b110)//ori 
            ALUControl = 3'b011;
        
        else if(func3 == 3'b010)//slti
            ALUControl = 3'b101;
    end
    else if (ALUOp == 3'b100) begin//jalr
        PCSrc = 2'b10;
        ALUControl = 3'b000;
    end 
    else if (ALUOp == 3'b011)//jal
        PCSrc = 2'b01;
    
end

endmodule






