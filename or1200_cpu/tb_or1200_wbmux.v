////////////////////////////////////////////////////////////////
//// Author:						    ////
////	- Balaji V. Iyer, bviyer@ncsu.edu		    ////
////////////////////////////////////////////////////////////////


`include "timescale.v"
`include "or1200_defines.v"

module tb_or1200_wbmux();

reg clk;
reg rst;
reg wb_freeze;
reg[`OR1200_RFWBOP_WIDTH-1:0]	rfwb_op;
reg[`OR1200_RFWBOP_WIDTH-1:0]	rfwb_op2;
reg[31:0] muxin_a;
reg[31:0] muxin_b;
reg[31:0] muxin_c;
reg[31:0] muxin_d;
reg[31:0] muxin_a2;
reg[31:0] muxin_b2;
reg[31:0] muxin_c2;
reg[31:0] muxin_d2;
wire[31:0] muxout;
wire[31:0] muxout2;

wire[31:0] muxreg;
wire[31:0] muxreg2;
wire muxreg_valid;
wire muxreg2_valid;


or1200_wbmux or1200_wbmux(.clk(clk), .rst(rst), .wb_freeze(wb_freeze),
  .rfwb_op(rfwb_op), .rfwb_op2(rfwb_op2), .muxin_a(muxin_a), .muxin_b(muxin_b),
  .muxin_c(muxin_c), .muxin_d(muxin_d), .muxin_a2(muxin_a2),.muxin_b2(muxin_b2),
  .muxin_c2(muxin_c2), .muxin_d2(muxin_d2), .muxout(muxout), .muxout2(muxout2),
  .muxreg(muxreg), .muxreg2(muxreg2), .muxreg_valid(muxreg_valid),
  .muxreg2_valid(muxreg2_valid));

initial begin

#0	rst=0;
	clk=0;

#10	rst=1;

#10	rst=0;
	wb_freeze=0;
	rfwb_op=3'b1;
	rfwb_op2=3'd3;
	muxin_a=32'h12345678;
	muxin_b=32'h23456789;
	muxin_c=32'h34567890;
	muxin_d=32'h4567890A;
	muxin_a2=32'h90ABCDEF;
	muxin_b2=32'h0ABCDEF9;
	muxin_c2=32'hABCDEF90;
	muxin_d2=32'hBCDEF90A;

#10	rfwb_op=3'd3;
	rfwb_op2=3'd5;



#10	rfwb_op=3'd5;
	rfwb_op2=3'd7;

#10	rfwb_op=3'd7;
	rfwb_op2=3'd1;

end

always #5 clk = ~clk;


endmodule
