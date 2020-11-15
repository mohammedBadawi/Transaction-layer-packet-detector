
//FSM TEST BECH

module tb;
reg clk,reset,datak;
reg [7:0] data_in;
wire [3:0]tlp_count;
wire [159:0] TLP;
wire MRd, MWr, IORd, IOWr, CfgRd0, CfgWr0, CfgRd1, CfgWr1, Cpl, CplD;
initial
begin
clk = 0;
reset = 0;
#12
reset = 1'b1;
datak = 1;
data_in = 8'hFB;
///////////////////////start of a packet
#11
reset=1'b1;
datak=0;
data_in = 8'h11;
#10
datak=0;
data_in = 8'h11;
#10
datak=0;
data_in = 8'h02;
#10
datak=0;
data_in = 8'h11;
#150
datak=1;
data_in = 8'hFD;
////////////////////////////End of successful packet (TLP_count=1)
#10
datak = 1;
data_in = 8'hFB;
#10
datak = 1;
data_in = 8'hFB;
#10
datak = 1;
data_in = 8'hFB;
///////////////////////////Three times repeated STP
#10
datak = 1;
data_in = 8'hFB;
/////////////////////////Start of the new real packet
#10
reset=1'b1;
datak=0;
data_in = 8'h33;
#10
datak=0;
data_in = 8'h44;
#10
datak=0;
data_in = 8'h04;
#10
datak=0;
data_in = 8'hff;
#150
datak=1;
data_in = 8'hFD;
#10
//////////////////////end of successful packet (TLP_count=2)
/////////////////////////Start of the new packet
datak = 1;
data_in = 8'hFB;
#10
reset=1'b1;
datak=0;
data_in = 8'h11;
#10
datak=0;
data_in = 8'h11;
#10
///////////////////////packet interuptted with a new one
datak = 1;
data_in = 8'hFB;
#10
/////////////////////////Start of the new real packet
reset=1'b1;
datak=0;
data_in = 8'hAA;
#10
datak=0;
data_in = 8'hBB;
#10
datak=0;
data_in = 8'h04;
#10
datak=0;
data_in = 8'h11;
#150
datak=1;
data_in = 8'hFD;
#10
//////////////////////end of successful packet (TLP_count=3)
$finish;
end
always #5 clk = ~clk;
always@(posedge clk)$monitor("%0dns: \$monitor: TLP =%h   ///  TLP_count=%d    //  TLP_Type=%b ", $stime,TLP,tlp_count,{MRd, MWr, IORd, IOWr, CfgRd0, CfgWr0, CfgRd1, CfgWr1, Cpl, CplD});
fsmd test (clk,reset,data_in,datak,tlp_count,TLP,CplD, Cpl, CfgWr1, CfgRd1, CfgWr0, CfgRd0, IOWr, IORd, MWr, MRd);
endmodule
