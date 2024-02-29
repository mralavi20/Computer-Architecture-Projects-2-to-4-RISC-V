


module datapath(input clk,rst, input [1:0] PCSrc,input MemWrite,input [1:0] ResultSrc,input [2:0] ALUControl,input ALUSrc,input [2:0] ImmSrc, input RegWrite,output sign, zero,output [6:0] func7,output [2:0] func3, output [6:0] op);

wire [31:0] WPCPlus4,WPCTarget,WPCNext,WPC,WInstr,WRD1,WRD2,WImmExt,WSrcB,WALUResult,WResult,WReadData;
mux4to1 mux1(PCSrc,WPCPlus4,WPCTarget,{WALUResult[31:2],2'b0},32'b1,WPCNext);
PC pc(clk,rst, WPCNext,WPC);
IM instruction_mem(WPC, WInstr);
adder adder1(WPC, 32'd4, WPCPlus4);
RegisterFile regfile(clk,RegWrite,WInstr[19:15], WInstr[24:20], WInstr[11:7], WResult,WRD1,WRD2);
Extend imm(WInstr[31:7], ImmSrc, WImmExt);
adder adder2(WPC,WImmExt,WPCTarget);
mux2to1 mux2(ALUSrc, WRD2,WImmExt,WSrcB);
ALU alu(WRD1,WSrcB, ALUControl,zero,sign, WALUResult);
DataMemory datamem(clk,MemWrite,WALUResult, WRD2,WReadData);
mux4to1 mux3(ResultSrc,WALUResult,WReadData,WPCPlus4,WImmExt,WResult);
assign op = WInstr[6:0];
assign func7 = WInstr[31:25];
assign func3 = WInstr[14:12];





endmodule
