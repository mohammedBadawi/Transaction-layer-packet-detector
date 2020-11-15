module decoder_tb;
reg [7:0] data_in;
wire [9:0]data_out;

initial
begin
$monitor("$monitor: data_in=%h   ///  data_out=%d ",data_in,data_out);
data_in = 8'h00;	//DATA_OUT = 1
#5
data_in = 8'h01;	//DATA_OUT = 2
#5
data_in = 8'h02;	//DATA_OUT = 4
#5
data_in = 8'h04;	//DATA_OUT = 16
#5
data_in = 8'h11;	//DATA_OUT = 0
end
decoder mydecoder(data_in ,data_out);
endmodule
