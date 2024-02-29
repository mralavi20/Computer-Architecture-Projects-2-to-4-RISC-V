



module ALUController(input [1:0] aluop,input [2:0] func3,input [6:0] func7, output reg [2:0] ALUControl);

always @(*)begin
    if(aluop == 2'b00)
        ALUControl = 3'b000;
    else if(aluop == 2'b10)begin
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
    else if(aluop == 2'b11)begin
        if (func3 == 3'b000)//addi
            ALUControl = 3'b000;

        else if(func3 == 3'b100)//xori
            ALUControl = 3'b110;

        else if(func3 == 3'b110)//ori 
            ALUControl = 3'b011;
        
        else if(func3 == 3'b010)//slti
            ALUControl = 3'b101;
    end
    else if(aluop == 2'b01)
        ALUControl = 3'b001;
end

endmodule 




