module Extend(input [24:0] In,input [2:0] ImmSrc, output reg [31:0] ImmExt);

always @(In,ImmSrc)
begin
case(ImmSrc)
3'b000: ImmExt <= {{20{In[24]}},In[24:13]};//i-type
3'b001 : ImmExt <= {{20{In[24]}},In[24:18],In[4:0]};//s-type
3'b010 : ImmExt <= {{19{In[24]}},In[24],In[0],In[23:18],In[4:1],1'b0};//b-type
3'b011 : ImmExt <= {{11{In[24]}},In[24], In[12:5],In[13],In[23:14],1'b0}; //j-type
3'b100 : ImmExt <= {In[24:5], 12'b0}; //lui

default : ImmExt <= 32'd0;
endcase
end
endmodule
