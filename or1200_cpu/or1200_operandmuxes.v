//////////////////////////////////////////////////////////////////////
////                                                              ////
////  OR1200's register file read operands mux                    ////
////                                                              ////
////  This file is part of the OpenRISC 1200 project              ////
////  http://www.opencores.org/cores/or1k/                        ////
////                                                              ////
////  Description                                                 ////
////  Mux for two register file read operands.                    ////
////                                                              ////
////  To Do:                                                      ////
////   - make it smaller and faster                               ////
////                                                              ////
////  Author(s):                                                  ////
////      - Damjan Lampret, lampret@opencores.org                 ////
////  Modified by:		                                  ////
////      - Balaji V. Iyer, bviyer@ncsu.edu                       ////
////  Advisor:			                                  ////
////      - Dr. Tom Conte 		                          ////
////								  ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright (C) 2000 Authors and OPENCORES.ORG                 ////
////                                                              ////
//// This source file may be used and distributed without         ////
//// restriction provided that this copyright statement is not    ////
//// removed from the file and that any derivative work contains  ////
//// the original copyright notice and the associated disclaimer. ////
////                                                              ////
//// This source file is free software; you can redistribute it   ////
//// and/or modify it under the terms of the GNU Lesser General   ////
//// Public License as published by the Free Software Foundation; ////
//// either version 2.1 of the License, or (at your option) any   ////
//// later version.                                               ////
////                                                              ////
//// This source is distributed in the hope that it will be       ////
//// useful, but WITHOUT ANY WARRANTY; without even the implied   ////
//// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      ////
//// PURPOSE.  See the GNU Lesser General Public License for more ////
//// details.                                                     ////
////                                                              ////
//// You should have received a copy of the GNU Lesser General    ////
//// Public License along with this source; if not, download it   ////
//// from http://www.opencores.org/lgpl.shtml                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS Revision History
//
// $Log: not supported by cvs2svn $
// Revision 1.2  2002/03/29 15:16:56  lampret
// Some of the warnings fixed.
//
// Revision 1.1  2002/01/03 08:16:15  lampret
// New prefixes for RTL files, prefixed module names. Updated cache controllers and MMUs.
//
// Revision 1.9  2001/11/12 01:45:40  lampret
// Moved flag bit into SR. Changed RF enable from constant enable to dynamic enable for read ports.
//
// Revision 1.8  2001/10/21 17:57:16  lampret
// Removed params from generic_XX.v. Added translate_off/on in sprs.v and id.v. Removed spr_addr from dc.v and ic.v. Fixed CR+LF.
//
// Revision 1.7  2001/10/14 13:12:09  lampret
// MP3 version.
//
// Revision 1.1.1.1  2001/10/06 10:18:36  igorm
// no message
//
// Revision 1.2  2001/08/09 13:39:33  lampret
// Major clean-up.
//
// Revision 1.1  2001/07/20 00:46:05  lampret
// Development version of RTL. Libraries are missing.
//
//

// synopsys translate_off
`include "timescale.v"
// synopsys translate_on
`include "or1200_defines.v"

module or1200_operandmuxes(
	// Clock and reset
	clk, rst,

	// Internal i/f
	id_freeze, ex_freeze, rf_dataa, rf_datab, ex_forw, wb_forw,
	rf_dataa2, rf_datab2, ex_forw2, wb_forw2,
	simm, sel_a, sel_b, operand_a, operand_b, muxed_b,
	simm2, sel_a2, sel_b2, operand_a2, operand_b2, muxed_b2,
	thread_in, thread_out
);

parameter width = 32;// `OR1200_OPERAND_WIDTH;

//
// I/O
//
input				clk;
input				rst;
input				id_freeze;
input				ex_freeze;
input	[width-1:0]		rf_dataa;
input	[width-1:0]		rf_datab;
input	[width-1:0]		rf_dataa2;
input	[width-1:0]		rf_datab2;
input	[width-1:0]		ex_forw;
input	[width-1:0]		wb_forw;
input	[width-1:0]		ex_forw2; // bviyer
input	[width-1:0]		wb_forw2; // bviyer
input	[width-1:0]		simm;
input	[width-1:0]		simm2;    // bviyer
input	[`OR1200_SEL_WIDTH-1:0]	sel_a;
input	[`OR1200_SEL_WIDTH-1:0]	sel_b;
input	[`OR1200_SEL_WIDTH-1:0]	sel_a2;	 // bviyer
input	[`OR1200_SEL_WIDTH-1:0]	sel_b2;  // bviyer
output	[width-1:0]		operand_a;
output	[width-1:0]		operand_b;
output	[width-1:0]		operand_a2; // bviyer
output	[width-1:0]		operand_b2; // bviyer
output	[width-1:0]		muxed_b;
output	[width-1:0]		muxed_b2;  // bviyer
input	[2:0]			thread_in; // bviyer
output  [2:0]			thread_out; // bviyer

//
// Internal wires and regs
//
reg	[width-1:0]		operand_a;
reg	[width-1:0]		operand_b;
reg	[width-1:0]		operand_a2;
reg	[width-1:0]		operand_b2;
reg	[width-1:0]		muxed_a;
reg	[width-1:0]		muxed_b;
reg	[width-1:0]		muxed_a2;
reg	[width-1:0]		muxed_b2;
reg				saved_a;
reg				saved_b;
reg				saved_a2;
reg				saved_b2;

//
// Operand A register
//
always @(posedge clk or posedge rst) begin
	if (rst) begin
		operand_a <=  32'd0;
		saved_a <=  1'b0;
	end else if (!ex_freeze && id_freeze && !saved_a) begin
		operand_a <=  muxed_a;
		saved_a <=  1'b1;
	end else if (!ex_freeze && !saved_a) begin
		operand_a <=  muxed_a;
	end else if (!ex_freeze && !id_freeze)
		saved_a <=  1'b0;
end

//
// Operand A register
//
// bviyer: this way we are making a room for anther set of input to make it two way.

always @(posedge clk or posedge rst) begin
	if (rst) begin
		operand_a2 <=  32'd0;
		saved_a2 <=  1'b0;
	end else if (!ex_freeze && id_freeze && !saved_a2) begin
		operand_a2 <=  muxed_a2;
		saved_a2 <=  1'b1;
	end else if (!ex_freeze && !saved_a2) begin
		operand_a2 <=  muxed_a2;
	end else if (!ex_freeze && !id_freeze)
		saved_a2 <=  1'b0;
end


//
// Operand B register
//
always @(posedge clk or posedge rst) begin
	if (rst) begin
		operand_b <=  32'd0;
		saved_b <=  1'b0;
	end else if (!ex_freeze && id_freeze && !saved_b) begin
		operand_b <=  muxed_b;
		saved_b <=  1'b1;
	end else if (!ex_freeze && !saved_b) begin
		operand_b <=  muxed_b;
	end else if (!ex_freeze && !id_freeze)
		saved_b <=  1'b0;
end
//
// Operand B register
//
// bviyer: same as waht we did for operand A
always @(posedge clk or posedge rst) begin
	if (rst) begin
		operand_b2 <=  32'd0;
		saved_b2 <=  1'b0;
	end else if (!ex_freeze && id_freeze && !saved_b2) begin
		operand_b2 <=  muxed_b2;
		saved_b2 <=  1'b1;
	end else if (!ex_freeze && !saved_b2) begin
		operand_b2 <=  muxed_b2;
	end else if (!ex_freeze && !id_freeze)
		saved_b2 <=  1'b0;
end

//
// Forwarding logic for operand A register
//
always @(ex_forw or wb_forw or rf_dataa or sel_a) begin
`ifdef OR1200_ADDITIONAL_SYNOPSYS_DIRECTIVES
	casex (sel_a)	// synopsys parallel_case infer_mux
`else
	casex (sel_a)	// synopsys parallel_case
`endif
		`OR1200_SEL_EX_FORW:
			muxed_a = ex_forw;
		`OR1200_SEL_WB_FORW:
			muxed_a = wb_forw;
		default:
			muxed_a = rf_dataa;
	endcase
end


//
// Forwarding logic for operand A register
//
// bviyer: forwarding logic for the 2nd a register.
always @(ex_forw2 or wb_forw2 or rf_dataa2 or sel_a2) begin
`ifdef OR1200_ADDITIONAL_SYNOPSYS_DIRECTIVES
	casex (sel_a2)	// synopsys parallel_case infer_mux
`else
	casex (sel_a2)	// synopsys parallel_case
`endif
		`OR1200_SEL_EX_FORW:
			muxed_a2 = ex_forw2;
		`OR1200_SEL_WB_FORW:
			muxed_a2 = wb_forw2;
		default:
			muxed_a2 = rf_dataa2;
	endcase
end





//
// Forwarding logic for operand B register
//
always @(simm or ex_forw or wb_forw or rf_datab or sel_b) begin
`ifdef OR1200_ADDITIONAL_SYNOPSYS_DIRECTIVES
	casex (sel_b)	// synopsys parallel_case infer_mux
`else
	casex (sel_b)	// synopsys parallel_case
`endif
		`OR1200_SEL_IMM:
			muxed_b = simm;
		`OR1200_SEL_EX_FORW:
			muxed_b = ex_forw;
		`OR1200_SEL_WB_FORW:
			muxed_b = wb_forw;
		default:
			muxed_b = rf_datab;
	endcase
end

//
// Forwarding logic for operand B register
//
// bviyer: forwarding logic for the 2nd b register

always @(simm2 or ex_forw2 or wb_forw2 or rf_datab2 or sel_b2) begin
`ifdef OR1200_ADDITIONAL_SYNOPSYS_DIRECTIVES
	casex (sel_b2)	// synopsys parallel_case infer_mux
`else
	casex (sel_b2)	// synopsys parallel_case
`endif
		`OR1200_SEL_IMM:
			muxed_b2 = simm2;
		`OR1200_SEL_EX_FORW:
			muxed_b2 = ex_forw2;
		`OR1200_SEL_WB_FORW:
			muxed_b2 = wb_forw2;
		default:
			muxed_b2 = rf_datab2;
	endcase
end


assign thread_out = thread_in;

endmodule
