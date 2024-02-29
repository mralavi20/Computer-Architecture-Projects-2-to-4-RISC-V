module Extend(input [24:0] In, input [6:0] op, output reg [31:0] ImmExt);

always @(op,In)
begin
if (op == 7'd3 || op == 7'd19 || op == 7'd103)
    ImmExt = {{20{In[24]}},In[24:13]};//i-type
else if (op == 7'd35)
    ImmExt = {{20{In[24]}},In[24:18],In[4:0]};//s-type
else if (op == 7'd99)
    ImmExt = {{19{In[24]}},In[24],In[0],In[23:18],In[4:1],1'b0};//b-type
else if (op == 7'd111)
    ImmExt = {{11{In[24]}},In[24], In[12:5],In[13],In[23:14],1'b0}; //j-type
else if (op == 7'd55)
    ImmExt = {In[24:5], 12'b0}; //lui
end
endmodule
