`include "timescale.v"
`include "or1200_defines.v"
////////////////////////////////////////////////////////////
//
// Author: Balaji V. Iyer, bviyer@ncsu.edu
// $Id: tb_or1200_ic_ram.v,v 1.1.1.1 2004-09-02 21:36:52 conte Exp $
// $Log: not supported by cvs2svn $
// $Revision: 1.1.1.1 $
////////////////////////////////////////////////////////////

module tb_or1200_ic_ram();

parameter dw = `OR1200_OPERAND_WIDTH;	// value is 32
parameter aw = `OR1200_ICINDX;		// value is 11

wire[63:0] dataout;
reg clk,rst;
reg [aw-1:0] addr;
reg [3:0] we;
reg [63:0] datain;
reg en;



initial begin
//  #100 $finish;
end

initial begin
  #0  	rst = 1;
	we = 0;
	en = 0;
	clk= 0;
	addr =11'b0;
       		
  #20	rst = 0;
  	en = 1;
      	addr= 11'b0;
  #10   addr= 11'd2;
  #10	addr= 11'd4;
  #10	addr= 11'd6;

end

always #5 clk = ~clk;

or1200_ic_ram or1200_ic_ram(.clk(clk), .rst(rst), .dataout(dataout),
  .addr(addr), .en(en), .we(we), .datain(datain));
endmodule
