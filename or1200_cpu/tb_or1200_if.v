////////////////////////////////////////////////////////////////////////
//// Author: 
////	- Balaji V. Iyer, bviyer@ncsu.edu
///////////////////////////////////////////////////////////////////////

`include "timescale.v"
`include "or1200_defines.v"
module tb_or1200_if();

reg rst;
reg clk;
reg [63:0] icpu_dat_i;
reg icpu_ack_i;
reg icpu_err_i;
reg [31:0] icpu_addr_i;
reg [3:0] icpu_tag_i;

reg if_freeze;
reg flushpipe;
reg no_more_dslot;
reg rfe;

wire [31:0] if_insn;
wire [31:0] if_insn2;
wire [31:0] if_pc;
wire if_stall;
wire genpc_refetch;
wire except_itlbmiss;
wire except_immufault;
wire except_ibuserr;

or1200_if or1200_if99(.clk(clk), .rst(rst), .icpu_dat_i(icpu_dat_i),
  .icpu_ack_i(icpu_ack_i), .icpu_err_i(icpu_err_i), .icpu_adr_i(icpu_addr_i),
  .icpu_tag_i(icpu_tag_i), .if_freeze(if_freeze), .if_insn(if_insn), 
  .if_insn2(if_insn2),.if_pc(if_pc), .flushpipe(flushpipe), .if_stall(if_stall),  .no_more_dslot(no_more_dslot), .genpc_refetch(genpc_refetch), .rfe(rfe),
  .except_itlbmiss(except_itlbmiss), .except_immufault(except_immufault),
  .except_ibuserr(except_ibuserr));

always #5 clk = ~clk;

initial begin
#10 	rst=1;
	clk=0;

#30	rst=0;
	icpu_dat_i=64'h1234567890ABCDEF;
	icpu_err_i=0;
	no_more_dslot=0;
	rfe=0;
	icpu_ack_i=1'b1;
	flushpipe=0;

#40	icpu_dat_i=64'h234567890ABCDEF1;
	icpu_err_i=1;
	icpu_tag_i=`OR1200_ITAG_PE;

#50	icpu_dat_i=64'h34567890ABCDEF12;
	icpu_tag_i=`OR1200_ITAG_BE;

#60	icpu_dat_i=64'h4567890ABCDEF123;
	icpu_tag_i=`OR1200_ITAG_TE;

#70	icpu_dat_i=64'h567890ABCDEF1234;

end
endmodule
