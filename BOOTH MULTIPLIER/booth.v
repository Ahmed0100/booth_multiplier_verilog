module booth(x,y,out);
input [5:0] x,y;
output [10:0] out;

reg [6:0] pp [0:2];
reg [10:0] correction_vector;
reg [2:0] coder [2:0] ;
wire [6:0] a,a_n,a2,a2_n;
assign a={~x[5],x};
assign a_n={x[5],~x};
assign a2={~x[5],x[4:0],1'b0};
assign a2_n={x[5],~x[4:0],1'b0};

	

assign out=pp[0]+{pp[1],2'b00}+{pp[2],4'b0000}+correction_vector;
always @*
	begin
	coder[0]=booth_encoder({x[1:0],1'b0});
	coder[1]=booth_encoder(x[3:1]);
	coder[2]=booth_encoder(x[5:3]);
	generate_pp (coder[0],a,a_n,a2,a2_n,pp[0],correction_vector[1:0]);
	generate_pp(coder[1],a,a_n,a2,a2_n,pp[1],correction_vector[3:2]);
	generate_pp(coder[2],a,a_n,a2,a2_n,pp[2],correction_vector[5:4]); 

	correction_vector[10:6]=5'b01011;
	end
task generate_pp;
input [2:0] coder;
input [6:0] a,a_n,a2,a2_n;
output [6:0] pp_task;
output [1:0] vector;

begin
	case(coder)
		3'b000: begin pp_task={1'b1,6'b0}; vector=2'b00; end
		3'b001: begin pp_task=a; vector=2'b00; end
		3'b010: begin pp_task=a2; vector=2'b00; end
		3'b110: begin pp_task=a2_n; vector=2'b10; end
		3'b111: begin pp_task=a_n; vector=2'b01; end
		default: begin pp_task=0; vector=2'b00;  end
	endcase  
end
endtask 

function [2:0] booth_encoder;
input [2:0] in;
	begin
	case(in)
		3'b000:  booth_encoder=3'b000;
		3'b001:  booth_encoder=3'b001;
		3'b010:  booth_encoder=3'b001;
		3'b011:  booth_encoder=3'b010;
		3'b100:  booth_encoder=3'b110;	
		3'b101:  booth_encoder=3'b111;
		3'b110:  booth_encoder=3'b111;			
		3'b111:  booth_encoder=3'b000;
		default : booth_encoder=3'b000;
	endcase
end
endfunction
endmodule 
		