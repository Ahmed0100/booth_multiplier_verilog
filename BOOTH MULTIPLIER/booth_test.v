module booth_test;
reg [5:0] x,y;
wire [10:0] out;

booth u1(x,y,out);
initial 
begin
	x=3; y=3; end
endmodule 