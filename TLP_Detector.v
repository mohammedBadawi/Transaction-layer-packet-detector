module TLP_Detector #(parameter width = 8) 
       (input clk,
	input reset,
	input [7:0] data_in,
	input datak,
	output reg [3:0]tlp_count,
	output reg [159:0] TLP,
	output  reg MRd,output  reg MWr,output  reg IORd,output  reg IOWr,
	output  reg CfgRd0,output  reg CfgWr0,output  reg CfgRd1,output  reg CfgWr1,output  reg Cpl,output  reg CplD
	);

//LOCLA VARIABLES
wire [width-1:0]count;
wire [9:0]decoder_out;
reg enable_counter,up_counter,reset_counter;
reg [159:0] packet;
reg[1:0] next_state,current_state;
reg[3:0]next_tlp_count;
//LOCAL PARAMETERS(STATES)
localparam [1:0]
	idle = 2'b00,
	stp = 2'b01,
	waiting=2'b10,
	finish=2'b11;

//CURRENT STATE FF
always @(posedge clk or negedge reset)
begin
if(!reset)
begin
current_state <= idle;
tlp_count <= 4'b0000;
end
else 
begin
current_state <= next_state;
tlp_count<=next_tlp_count;
end
end

//NEXT STATE LOGIC BLOCK
always @(*)
begin
case(current_state)
idle:
	if(datak && data_in == 8'hFB) next_state = stp;
	else next_state = idle;

stp:
	if(datak && data_in == 8'hFB) next_state = stp;
	else if(datak && data_in !== 8'hFB) next_state = idle;
	else next_state = waiting;
waiting:
	if(count == 17 && datak && data_in == 8'hFD)next_state = finish;
	else if(datak && data_in == 8'hFB) next_state = stp;
	else if(count < 17 && !datak)next_state = waiting;
	else next_state = idle;

finish:
	 if(datak && data_in == 8'hFB) next_state = stp;
	 else next_state = idle;
default:next_state = idle;
endcase 
end

//OUTPUT LOGIC BLOCK
always @(*)
begin
case(current_state)
idle:
	begin
	
	enable_counter = 1'b0;
	up_counter = 1'bx;
	reset_counter = 1'b0;
	end
stp:
	begin
	
	enable_counter = 1'b0;
	up_counter = 1'bx;
	reset_counter = 1'b0;
	end
waiting:
	begin
	
	reset_counter = 1'b1;
	enable_counter = 1'b1;
	up_counter = 1'b1;

	end
finish:
	begin
	
	enable_counter = 1'b0;
	up_counter = 1'bx;
	reset_counter = 1'b0;
	end

default:
	begin
	
	enable_counter = 1'b0;
	up_counter = 1'bx;
	reset_counter = 1'b0;

	end 
endcase
end

//SHIFT REGISTER (ONLY WIRING) FOR DATA_IN
always@(posedge clk)
begin
if(data_in==8'hFD && datak &&packet[15:8]==8'hFB && (current_state ==waiting|| current_state==finish)&&count == 17)
begin
TLP<={8'hFD,packet[159:8]};
{CplD, Cpl, CfgWr1, CfgRd1, CfgWr0, CfgRd0, IOWr, IORd, MWr, MRd}<=decoder_out;
end

else 
begin
TLP<=160'b0;
{CplD, Cpl, CfgWr1, CfgRd1, CfgWr0, CfgRd0, IOWr, IORd, MWr, MRd}<=10'b0;
end
packet<={data_in,packet[159:8]};
end

//GOOD TLPs COUNTER BLOCK
always@(*)
if(data_in==8'hFD && datak &&packet[15:8]==8'hFB && (current_state ==waiting|| current_state==finish)&&count == 17)
next_tlp_count<=tlp_count+1'b1;
else
next_tlp_count<=tlp_count;

//MODULES INSTANCES
counter#(.width(width))fsmcounter(.clk(clk),.reset(reset_counter),.up(up_counter),.enable(enable_counter),.count(count));
decoder fsmdecoder(packet[39:32] ,decoder_out);


endmodule

