module counter_tb;
reg reset , clk, enable, up;
wire [7 : 0] count;
initial
begin
clk = 0;
reset = 0;
#16
reset = 1;
enable = 1;
up = 1;
#60
up = 0;
#60
$finish;
end
always 
#5 clk = ~clk;
always @(posedge clk)
$monitor("%0dns: \$monitor: count=%b ", $stime, count);
counter#(.width(8))mcounter(.clk(clk),.reset(reset),.up(up),.enable(enable),.count(count)); 

endmodule 