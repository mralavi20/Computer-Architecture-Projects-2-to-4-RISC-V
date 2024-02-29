



module MultiCycleRiscV(input clk,rst);
    wire WMemWrite,WRegWrite,WPCWrite,WIrWrite,WWdSel,WAdrSrc,WZero,Wsign;
    wire [1:0] WAluSrcA,WAluSrcB,WResultSrc,WAluOP;
    wire [2:0] WAluControl,WFunc3;
    wire [6:0] WOP,WFunc7;
    datapath dp(clk,rst,WMemWrite,WRegWrite,WPCWrite,WIrWrite,WWdSel,WAdrSrc,WAluSrcA,WAluSrcB, WAluControl, WResultSrc, WZero,Wsign, WOP, WFunc3,WFunc7);
    ALUController AC(WAluOP,WFunc3,WFunc7,WAluControl);
    controller maincontrol(clk,rst,WZero,Wsign,WOP,WFunc3,WMemWrite,WRegWrite,WPCWrite,WIrWrite,WWdSel,WAdrSrc,WAluSrcA,WAluSrcB,WAluOP,WResultSrc);

endmodule
