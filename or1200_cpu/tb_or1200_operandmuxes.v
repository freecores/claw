`include "timescale.v"
`include "or1200_defines.v"

////////////////////////////////////////////////////////////////////
//// Author: Balaji V. Iyer, bviyer@ncsu.edu			////
////////////////////////////////////////////////////////////////////


module tb_or1200_operandmuxes();

reg clk;
reg rst;
reg id_freeze;
reg ex_freeze;
reg[31:0] rf_dataa;
reg[31:0] rf_datab;
reg[31:0] rf_dataa2;
reg[31:0] rf_datab2;
reg[31:0] ex_forw;
reg[31:0] wb_forw;
reg[31:0] ex_forw2;
reg[31:0] wb_forw2;
reg[31:0] simm;
reg[31:0] simm2;
reg[`OR1200_SEL_WIDTH-1:0] sel_a;
reg[`OR1200_SEL_WIDTH-1:0] sel_b;
reg[`OR1200_SEL_WIDTH-1:0] sel_a2;
reg[`OR1200_SEL_WIDTH-1:0] sel_b2;

wire [31:0] operand_a;
wire [31:0] operand_b;
wire [31:0] operand_a2;
wire [31:0] operand_b2;

wire [31:0] muxed_b;
wire [31:0] muxed_b2;


or1200_operandmuxes or1200_operandmuxes(.clk(clk), .rst(rst),
	 .id_freeze(id_freeze), .ex_freeze(ex_freeze), .rf_dataa(rf_dataa),
  	.rf_datab(rf_datab), .rf_dataa2(rf_dataa2), .rf_datab2(rf_datab2),
	.ex_forw(ex_forw), .wb_forw(wb_forw), .ex_forw2(ex_forw2), 
	.wb_forw2(wb_forw2), .simm(simm), .simm2(simm2), .sel_a(sel_a),
        .sel_b(sel_b), .sel_a2(sel_a2), .sel_b2(sel_b2), .operand_a(operand_a),
	.operand_b(operand_b), .operand_a2(operand_a2),.operand_b2(operand_b2),
	.muxed_b(muxed_b),.muxed_b2(muxed_b2));

initial begin
#0	rst=0;
	clk=0;
#10	rst=1;

#10	rst=0;	  
	ex_freeze=0;
	id_freeze=0;
	ex_forw=32'h12345678;
	wb_forw=32'h90ABCDEF;
	ex_forw2=32'h23456781;
	wb_forw2=32'h0ABCDEF9;
	rf_dataa = 32'hBA1A7EEE;	// yeye this almost spells my name
	rf_datab= 32'hEEE7A1AB;
	rf_dataa2= 32'h1A7EEEBA;		
	rf_datab2= 32'hE7A1ABEE;
	sel_a=`OR1200_SEL_EX_FORW;
	sel_a2=32'b0;
	sel_b=`OR1200_SEL_WB_FORW;
	sel_b2=32'b0;

#10	rst=0;	  
	ex_freeze=0;
	id_freeze=0;
	rf_dataa= 32'hBA1A7EEE;		// yeye this almost spells my name
	rf_datab= 32'hEEE7A1AB;
	rf_dataa2= 32'h1A7EEEBA;		
	rf_datab2= 32'hE7A1ABEE;
	ex_forw=32'h12345678;
	wb_forw=32'h90ABCDEF;
	ex_forw2=32'h23456781;
	wb_forw2=32'h0ABCDEF9;
	sel_a2=`OR1200_SEL_EX_FORW;
	sel_a=32'b0;
	sel_b2=`OR1200_SEL_WB_FORW;
	sel_b=32'b0;

end
always #5 clk = ~clk;

endmodule
