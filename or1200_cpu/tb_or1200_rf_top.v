////////////////////////////////////////////////////////////////////
////  Author:							////
////	 - Balaji V. Iyer, bviyer@ncsu.edu		        ////
////////////////////////////////////////////////////////////////////

`include "timescale.v"
`include "or1200_defines.v"


module tb_or1200_rf_top();

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

wire[2:0] current_thread_read_out;
reg[2:0] current_thread_read;
reg[2:0] current_thread_write;


or1200_rf_top or1200_rf_top(.clk(clk), .rst(rst), .supv(supv), 
  .wb_freeze(wb_freeze), .current_thread_read(current_thread_read),
  .addrw(addrw), .dataw(dataw), .addrw2(addrw2), .dataw2(dataw2), .we(we),
  .we2(we2), .flushpipe (flushpipe), .id_freeze(id_freeze), .addra(addra),
  .addrb(addrb), .dataa(dataa), .datab(datab), .rda(rda), .rdb(rdb),
  .addra2(addra2), .addrb2(addrb2), .dataa2(dataa2), 
  .datab2(datab2), .rda2(rda2), .rdb2(rdb2), .spr_cs(spr_cs), 
  .spr_write(spr_write), .spr_addr(spr_addr), .spr_dat_i(spr_dat_i), 
  .spr_dat_o(spr_dat_o), .current_thread_read_out(current_thread_read_out),
  .current_thread_write(current_thread_write));

initial begin
  #0	clk=0;
	rst=0;


  #10	rst=1;
        current_thread_write=3'bX;
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
	current_thread_write = 3'b0;

  #10   id_freeze=0;
 
  #20	spr_write=0;
	id_freeze=0;
	we=0;
	we2=0;
	rda=1;
	rda2=1;
	addra=5'd1;
	addra2=5'd2;
	current_thread_read=3'd0;

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
	current_thread_write=3'd0;

  #20	spr_write=0;
	id_freeze=0;
	we=0;
	we2=0;
	rdb=1;
	rdb2=1;
	addrb=5'd13;
	addrb2=5'd14;
	current_thread_read=3'd0;

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
        current_thread_write=3'd1;

  #10   id_freeze=0;
 
  #20	spr_write=0;
	id_freeze=0;
	we=0;
	we2=0;
	rda=1;
	rda2=1;
	addra=5'd1;
	addra2=5'd2;
        current_thread_read=3'd1;

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
	current_thread_write=3'd1;

  #20	spr_write=0;
	id_freeze=0;
	we=0;
	we2=0;
	rdb=1;
	rdb2=1;
	addrb=5'd13;
	addrb2=5'd14;
        current_thread_read=3'd1;

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
	dataw =32'h11111112;
	dataw2 =32'h2AAAAAAA;
	current_thread_write=3'd2;

  #10   id_freeze=0;
 
  #20	spr_write=0;
	id_freeze=0;
	we=0;
	we2=0;
	rda=1;
	rda2=1;
	addra=5'd1;
	addra2=5'd2;
	current_thread_read=3'd2;

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
	dataw =32'h31111111;
	dataw2 =32'h3BBBBBBB;
	current_thread_write=3'd2;

  #20	spr_write=0;
	id_freeze=0;
	we=0;
	we2=0;
	rdb=1;
	rdb2=1;
	addrb=5'd13;
	addrb2=5'd14;
	current_thread_read=3'd2;

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
	dataw =32'h43333333;
	dataw2 =32'h4CCCCCCC;
	current_thread_write=3'd3;

  #10   id_freeze=0;
 
  #20	spr_write=0;
	id_freeze=0;
	we=0;
	we2=0;
	rda=1;
	rda2=1;
	addra=5'd1;
	addra2=5'd2;
	current_thread_read=3'd3;

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
	current_thread_write=3'd3;

  #20	spr_write=0;
	id_freeze=0;
	we=0;
	we2=0;
	rdb=1;
	rdb2=1;
	addrb=5'd13;
	addrb2=5'd14;
	current_thread_read=3'd3;

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
	current_thread_write=3'd4;

  #10   id_freeze=0;
 
  #20	spr_write=0;
	id_freeze=0;
	we=0;
	we2=0;
	rda=1;
	rda2=1;
	addra=5'd1;
	addra2=5'd2;
	current_thread_read=3'd4;

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
	dataw =32'h01323434;
	dataw2 =32'h23389321;
	current_thread_write=3'd4;

  #20	spr_write=0;
	id_freeze=0;
	we=0;
	we2=0;
	rdb=1;
	rdb2=1;
	addrb=5'd13;
	addrb2=5'd14;
	current_thread_read=3'd4;

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
	dataw =32'h13456782;
	dataw2 =32'h9AABCDEF;
	current_thread_write=3'd5;

  #10   id_freeze=0;
 
  #20	spr_write=0;
	id_freeze=0;
	we=0;
	we2=0;
	rda=1;
	rda2=1;
	addra=5'd1;
	addra2=5'd2;
	current_thread_read=3'd5;

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
	dataw =32'h34567829;
	dataw2 =32'h0ABCDE1F;
	current_thread_write=3'd5;

  #20	spr_write=0;
	id_freeze=0;
	we=0;
	we2=0;
	rdb=1;
	rdb2=1;
	addrb=5'd13;
	addrb2=5'd14;
	current_thread_read=3'd5;
end

always #5 clk = ~clk;
endmodule
