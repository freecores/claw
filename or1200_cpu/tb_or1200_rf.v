////////////////////////////////////////////////////////////////////
////  Author:							////
////	 - Balaji V. Iyer, bviyer@ncsu.edu		        ////
////////////////////////////////////////////////////////////////////

`include "timescale.v"
`include "or1200_defines.v"


module tb_or1200_rf();

parameter aw = 5;  //`OR1200_REGFILE_ADDR_WIDTH;
parameter dw = 32;// `OR1200_OPERAND_WIDTH;

reg clk;
reg rst;
reg supv;
reg wb_freeze;
reg [aw-1:0] addrw;
reg [dw-1:0] dataw;
reg we;
reg we2;
reg flushpipe;

reg [aw-1:0] addrw2;
reg [dw-1:0] dataw2;

reg id_freeze;
reg [aw-1:0] addra;
reg [aw-1:0] addrb;
wire [dw-1:0] dataa;
wire [dw-1:0] datab;
reg rda;
reg rdb;

reg [aw-1:0] addra2;
reg [aw-1:0] addrb2;
wire [dw-1:0] dataa2;
wire [dw-1:0] datab2;
reg rda2;
reg rdb2;

reg spr_cs;
reg spr_write;
reg [31:0] spr_addr;
reg [31:0] spr_dat_i;
wire [31:0] spr_dat_o;

or1200_rf or1200_rf(.clk(clk), .rst(rst), .supv(supv), .wb_freeze(wb_freeze),
  .addrw(addrw), .dataw(dataw), .addrw2(addrw2), .dataw2(dataw2), .we(we),
  .we2(we2), .flushpipe (flushpipe), .id_freeze(id_freeze), .addra(addra),
  .addrb(addrb), .dataa(dataa), .datab(datab), .rda(rda), .rdb(rdb),
  .addra2(addra2), .addrb2(addrb2), .dataa2(dataa2), 
  .datab2(datab2), .rda2(rda2), .rdb2(rdb2), .spr_cs(spr_cs), 
  .spr_write(spr_write), .spr_addr(spr_addr), .spr_dat_i(spr_dat_i), 
  .spr_dat_o(spr_dat_o));


initial begin
  #0	clk=0;
	rst=0;


  #10	rst=1;

  #10	rst=0;
	wb_freeze=0;
	flushpipe=0;
	spr_cs=0;
	spr_addr=32'b0;
	spr_write=0;
	addrw =5'd1;
	addrw2=5'd2;
	we=1;
	we2=1;
	rda=0;
	rda2=0;
	supv=1;
	dataw =32'h12345678;
	dataw2 =32'h90ABCDEF;

  #10   id_freeze=0;
 
  #20	spr_write=0;
	id_freeze=0;
	we=0;
	we2=0;
	rda=1;
	rda2=1;
	addra=5'd1;
	addra2=5'd2;

  #20	rst=0;
	wb_freeze=0;
	flushpipe=0;
	spr_cs=0;
	spr_addr[10:5]=6'b0;
	spr_write=0;
	addrw =5'd13;
	addrw2=5'd14;
        rda=0;
	rda2=0;
	we=1;
	we2=1;
	supv=1;
	dataw =32'h23456789;
	dataw2 =32'h0ABCDEF1;

  #20	spr_write=0;
	id_freeze=0;
	we=0;
	we2=0;
	rdb=1;
	rdb2=1;
	addrb=5'd13;
	addrb2=5'd14;
end

always #5 clk = ~clk;
endmodule
