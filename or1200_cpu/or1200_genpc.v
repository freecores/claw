//////////////////////////////////////////////////////////////////////
////                                                              ////
////  OR1200's generate PC                                        ////
////                                                              ////
////  This file is part of the OpenRISC 1200 project              ////
////  http://www.opencores.org/cores/or1k/                        ////
////                                                              ////
////  Description                                                 ////
////  PC, interface to IC.                                        ////
////                                                              ////
////  To Do:                                                      ////
////   - make it smaller and faster                               ////
////                                                              ////
////  Author(s):                                                  ////
////      - Damjan Lampret, lampret@opencores.org                 ////
////                                                              ////
////  Modified by:                                                ////
////      - Balaji V. Iyer, bviyer@ncsu.edu                       ////
////  Advisor: 							  ////
////	  - Dr. Tom Conte	                          	  ////
////                                                              ////
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
// Revision 1.9  2004/04/05 08:29:57  lampret
// Merged branch_qmem into main tree.
//
// Revision 1.7.4.3  2003/12/17 13:43:38  simons
// Exception prefix configuration changed.
//
// Revision 1.7.4.2  2003/12/04 23:44:31  lampret
// Static exception prefix.
//
// Revision 1.7.4.1  2003/07/08 15:36:37  lampret
// Added embedded memory QMEM.
//
// Revision 1.7  2003/04/20 22:23:57  lampret
// No functional change. Only added customization for exception vectors.
//
// Revision 1.6  2002/03/29 15:16:55  lampret
// Some of the warnings fixed.
//
// Revision 1.5  2002/02/11 04:33:17  lampret
// Speed optimizations (removed duplicate _cyc_ and _stb_). Fixed D/IMMU cache-inhibit attr.
//
// Revision 1.4  2002/01/28 01:16:00  lampret
// Changed 'void' nop-ops instead of insn[0] to use insn[16]. Debug unit stalls the tick timer. Prepared new flag generation for add and and insns. Blocked DC/IC while they are turned off. Fixed I/D MMU SPRs layout except WAYs. TODO: smart IC invalidate, l.j 2 and TLB ways.
//
// Revision 1.3  2002/01/18 07:56:00  lampret
// No more low/high priority interrupts (PICPR removed). Added tick timer exception. Added exception prefix (SR[EPH]). Fixed single-step bug whenreading NPC.
//
// Revision 1.2  2002/01/14 06:18:22  lampret
// Fixed mem2reg bug in FAST implementation. Updated debug unit to work with new genpc/if.
//
// Revision 1.1  2002/01/03 08:16:15  lampret
// New prefixes for RTL files, prefixed module names. Updated cache controllers and MMUs.
//
// Revision 1.10  2001/11/20 18:46:15  simons
// Break point bug fixed
//
// Revision 1.9  2001/11/18 09:58:28  lampret
// Fixed some l.trap typos.
//
// Revision 1.8  2001/11/18 08:36:28  lampret
// For GDB changed single stepping and disabled trap exception.
//
// Revision 1.7  2001/10/21 17:57:16  lampret
// Removed params from generic_XX.v. Added translate_off/on in sprs.v and id.v. Removed spr_addr from dc.v and ic.v. Fixed CR+LF.
//
// Revision 1.6  2001/10/14 13:12:09  lampret
// MP3 version.
//
// Revision 1.1.1.1  2001/10/06 10:18:36  igorm
// no message
//
// Revision 1.1  2001/08/09 13:39:33  lampret
// Major clean-up.
//
//

// synopsys translate_off
 `include "timescale.v"
// synopsys translate_on
 `include "or1200_defines.v"

module or1200_genpc(
	// Clock and reset
	clk, rst,

	// External i/f to IC
	icpu_adr_o, icpu_cycstb_o, icpu_sel_o, icpu_tag_o,
	icpu_rty_i, icpu_adr_i,

	// Internal i/f
	branch_op, except_type, except_prefix,
	branch_addrofs, lr_restor, flag, taken, except_start,
	binsn_addr, epcr, spr_dat_i, spr_pc_we, genpc_refetch,
	genpc_freeze, genpc_stop_prefetch, no_more_dslot,
	thread_out, branch_thread,wb_thread, except_thread
);

//
// I/O
//

//
// Clock and reset
//
input				clk;
input				rst;

//
// External i/f to IC
//
output	[31:0]			icpu_adr_o;
output				icpu_cycstb_o;
output	[3:0]			icpu_sel_o;
output	[3:0]			icpu_tag_o;
input				icpu_rty_i;
input	[31:0]			icpu_adr_i;

//
// Internal i/f
//
input	[`OR1200_BRANCHOP_WIDTH-1:0]	branch_op;
input	[`OR1200_EXCEPT_WIDTH-1:0]	except_type;
input					except_prefix;
input	[31:2]			branch_addrofs;
input	[31:0]			lr_restor;
input				flag;
output				taken;
input				except_start;
input	[31:2]			binsn_addr;
input	[31:0]			epcr;
input	[31:0]			spr_dat_i;
input				spr_pc_we;
input				genpc_refetch;
input				genpc_stop_prefetch;
input				genpc_freeze;
input				no_more_dslot;
input [2:0]			branch_thread;	// bviyer
input [2:0]			except_thread;	// bviyer
input [2:0]			wb_thread;	// bviyer
output [2:0]			thread_out;	// bviyer
//
// Internal wires and regs
//
reg	[31:2]			pcreg;
reg	[31:0]			pc;
reg				taken;	/* Set to in case of jump or taken branch */
reg				genpc_refetch_r;
 reg [31:0]			temp_icpu_adr_o;
//
// bviyer: Thread registers
//

// reg [2:0] thread_out;
reg [2:0] temp_thread_out;
reg [2:0] thread_out;
reg  [2:0] current_thread;
reg [2:0] some_thread;
reg [2:0] next_thread;

// bviyer: different registers
reg	[31:2]			pcreg_1;
reg	[31:2]			pcreg_2;
reg	[31:2]			pcreg_3;
reg	[31:2]			pcreg_4;
reg	[31:2]			pcreg_5;
reg	[31:2]			pcreg_6;
reg	[31:2]			pcreg_7;
reg	[31:2]			pcreg_8;

//
// Address of insn to be fecthed
//
// assign icpu_adr_o = !no_more_dslot & !except_start & !spr_pc_we & (icpu_rty_i | genpc_refetch) ? icpu_adr_i : pc;
// assign icpu_adr_o = !except_start & !spr_pc_we & (icpu_rty_i | genpc_refetch) ? icpu_adr_i : pc;

//
// Control access to IC subsystem
//
// assign icpu_cycstb_o = !genpc_freeze & !no_more_dslot;
assign icpu_cycstb_o = !genpc_freeze; // works, except remaining raised cycstb during long load/store
//assign icpu_cycstb_o = !(genpc_freeze | genpc_refetch & genpc_refetch_r);
//assign icpu_cycstb_o = !(genpc_freeze | genpc_stop_prefetch);
assign icpu_sel_o = 4'b1111;
assign icpu_tag_o = `OR1200_ITAG_NI;
assign icpu_adr_o = temp_icpu_adr_o;
// assign thread_out =   temp_thread_out; 
//
// genpc_freeze_r
//

 always @(posedge clk)
 begin
temp_icpu_adr_o = !no_more_dslot & !except_start & !spr_pc_we & (icpu_rty_i | genpc_refetch) ? icpu_adr_i : pc;
thread_out =   temp_thread_out; 
// temp_thread_out = current_thread;
end

always @(posedge clk or posedge rst)
	if (rst)
		genpc_refetch_r <=  1'b0;
	else if (genpc_refetch)
		genpc_refetch_r <=  1'b1;
	else
		genpc_refetch_r <=  1'b0;

//
// Async calculation of new PC value. This value is used for addressing the IC.
// bviyer: modified for the multithreaded architecture
 always @(rst or branch_thread or except_thread or wb_thread or  current_thread or pcreg_1 or pcreg_2 or pcreg_3 or pcreg_4 or pcreg_5 or pcreg_6 or pcreg_7 or pcreg_8 or  branch_addrofs or binsn_addr or flag or branch_op or except_type or except_start or lr_restor or epcr or spr_pc_we or spr_dat_i or except_prefix) begin

// always @(posedge clk or posedge rst)
// begin
	if (rst) begin  
           next_thread <= 3'd0;
	   temp_thread_out <= 3'd0;
	   pc <= {pcreg_1,2'b0}; end
        else
        begin 
	casex ({spr_pc_we, except_start, branch_op})	// synopsys parallel_case
		{2'b00, `OR1200_BRANCHOP_NOP}: begin
			taken <= 1'b0;
			case (current_thread)	// synopsys parallel_case
			3'd0:	
				pc <= {pcreg_1 + 2'd2, 2'b0};
			3'd1:	
				pc <= {pcreg_2 + 2'd2, 2'b0};
			3'd2:	
				pc <= {pcreg_3 + 2'd2, 2'b0};
			3'd3:
				pc <= {pcreg_4 + 2'd2, 2'b0};
			3'd4:	
				pc <= {pcreg_5 + 2'd2, 2'b0};
			3'd5:
				pc <= {pcreg_6 + 2'd2, 2'b0};
			3'd6:
				pc <= {pcreg_7 + 2'd2, 2'b0};
			3'd7:
				pc <= {pcreg_8 + 2'd2, 2'b0};
			endcase
			temp_thread_out <= current_thread; // next_thread; // {temp_thread_out + 3'd1};
			next_thread[0] <= !current_thread[0];
			next_thread[1] <= current_thread[1] ^
					  current_thread[0];
			next_thread[2] <= current_thread[2] ^
					(current_thread[0] & current_thread[1]);
			temp_thread_out <= current_thread; // next_thread; // {temp_thread_out + 3'd1};
/*
			temp_thread_out[0] <= !temp_thread_out[0];
			temp_thread_out[1] <= temp_thread_out[1] ^ temp_thread_out[0];
			temp_thread_out[2] <= temp_thread_out[2] ^ (temp_thread_out[1] & temp_thread_out[0]);
*/
		end
		{2'b00, `OR1200_BRANCHOP_J}: begin
`ifdef OR1200_VERBOSE
// synopsys translate_off
			$display("%t: BRANCHOP_J: pc <= branch_addrofs %h", $time, branch_addrofs);
// synopsys translate_on
`endif
			pc <= {branch_addrofs, 2'b0};
			taken <= 1'b1;
			next_thread <= branch_thread;
			temp_thread_out <= branch_thread; // current_thread;
		end
		{2'b00, `OR1200_BRANCHOP_JR}: begin
`ifdef OR1200_VERBOSE
// synopsys translate_off
			$display("%t: BRANCHOP_JR: pc <= lr_restor %h", $time, lr_restor);
// synopsys translate_on
`endif
			pc <= lr_restor;
			taken <= 1'b1;
			next_thread <= branch_thread;
			temp_thread_out <= branch_thread; //  current_thread;
		end
		{2'b00, `OR1200_BRANCHOP_BAL}: begin
`ifdef OR1200_VERBOSE
// synopsys translate_off
			$display("%t: BRANCHOP_BAL: pc %h = binsn_addr %h + branch_addrofs %h", $time, binsn_addr + branch_addrofs, binsn_addr, branch_addrofs);
// synopsys translate_on
`endif
			pc <= {binsn_addr + branch_addrofs, 2'b0};
			taken <= 1'b1;
			next_thread <= wb_thread;
			temp_thread_out <= wb_thread; // current_thread;
		end
		{2'b00, `OR1200_BRANCHOP_BF}:
			if (flag) begin
`ifdef OR1200_VERBOSE
// synopsys translate_off
				$display("%t: BRANCHOP_BF: pc %h = binsn_addr %h + branch_addrofs %h", $time, binsn_addr + branch_addrofs, binsn_addr, branch_addrofs);
// synopsys translate_on
`endif
				pc <= {binsn_addr + branch_addrofs, 2'b0};
				taken <= 1'b1;
				next_thread <= wb_thread;
				temp_thread_out <= wb_thread;
			end
			else begin
`ifdef OR1200_VERBOSE
// synopsys translate_off
			$display("%t: BRANCHOP_BF: not taken", $time);
// synopsys translate_on
`endif
				taken <= 1'b0;
			case (current_thread) // synopsys parallel_case
			3'd0:	
				pc <= {pcreg_1 + 2'd2, 2'b0};
			3'd1:	
				pc <= {pcreg_2 + 2'd2, 2'b0};
			3'd2:	
				pc <= {pcreg_3 + 2'd2, 2'b0};
			3'd3:
				pc <= {pcreg_4 + 2'd2, 2'b0};
			3'd4:	
				pc <= {pcreg_5 + 2'd2, 2'b0};
			3'd5:
				pc <= {pcreg_6 + 2'd2, 2'b0};
			3'd6:
				pc <= {pcreg_7 + 2'd2, 2'b0};
			3'd7:
				pc <= {pcreg_8 + 2'd2, 2'b0};
			endcase
			next_thread  <= {current_thread+3'd1};
			temp_thread_out <= current_thread;
			end
		{2'b00, `OR1200_BRANCHOP_BNF}:
			if (flag) begin
			case (current_thread)	// synopsys parallel_case
			3'd0:	
				pc <= {pcreg_1 + 2'd2, 2'b0};
			3'd1:	
				pc <= {pcreg_2 + 2'd2, 2'b0};
			3'd2:	
				pc <= {pcreg_3 + 2'd2, 2'b0};
			3'd3:
				pc <= {pcreg_4 + 2'd2, 2'b0};
			3'd4:	
				pc <= {pcreg_5 + 2'd2, 2'b0};
			3'd5:
				pc <= {pcreg_6 + 2'd2, 2'b0};
			3'd6:
				pc <= {pcreg_7 + 2'd2, 2'b0};
			3'd7:
				pc <= {pcreg_8 + 2'd2, 2'b0};
			endcase

			next_thread  <= {current_thread+3'd1};
			temp_thread_out <= current_thread;
`ifdef OR1200_VERBOSE
// synopsys translate_off
				$display("%t: BRANCHOP_BNF: not taken", $time);
// synopsys translate_on
`endif
				taken <= 1'b0;
			end
			else begin
`ifdef OR1200_VERBOSE
// synopsys translate_off
	$display("%t: BRANCHOP_BNF: pc %h = binsn_addr %h + branch_addrofs %h", $time, binsn_addr + branch_addrofs, binsn_addr, branch_addrofs);
// synopsys translate_on
`endif
				pc <= {binsn_addr + branch_addrofs, 2'b0};
				taken <= 1'b1;
				next_thread <= branch_thread;
				temp_thread_out <= current_thread;
				// current_thread = branch_thread;
			end
		{2'b00, `OR1200_BRANCHOP_RFE}: begin
`ifdef OR1200_VERBOSE
// synopsys translate_off
			$display("%t: BRANCHOP_RFE: pc <= epcr %h", $time, epcr);
// synopsys translate_on
`endif
			pc <= epcr;
			taken <= 1'b1;
			next_thread <= branch_thread;
			temp_thread_out <= current_thread;
		//	current_thread = branch_thread;
		end
		{2'b01, 3'bxxx}: begin
`ifdef OR1200_VERBOSE
// synopsys translate_off
			$display("Starting exception: %h.", except_type);
// synopsys translate_on
`endif
			pc <= {(except_prefix ? `OR1200_EXCEPT_EPH1_P : `OR1200_EXCEPT_EPH0_P), except_type, `OR1200_EXCEPT_V};
			taken <= 1'b1;
			next_thread <= except_thread;
			temp_thread_out <= current_thread; //  except_thread;
			//current_thread = except_thread;
		end
		default: begin
`ifdef OR1200_VERBOSE
// synopsys translate_off
			$display("l.mtspr writing into PC: %h.", spr_dat_i);
// synopsys translate_on
`endif
			pc <= spr_dat_i;
			taken <= 1'b0;
			next_thread <= except_thread;
			temp_thread_out <= current_thread;
		end
	endcase
	end
 end
//bviyer
// assign thread_out = next_thread;

//bviyer


always @(rst or some_thread)
begin
  if (rst) 
     current_thread = 3'd0;
  else 
    current_thread = some_thread;
end

//
// PC register
// bviyer: modified for multithreading
always @(posedge clk or posedge rst)
	if (rst) begin
	some_thread = 3'd0;
`ifdef BALAJI_TESTING
	  pcreg<=32'b0;
	  pcreg_1<=32'h10;
	  pcreg_2<=32'h20;
	  pcreg_3<=32'h30;
	  pcreg_4<=32'h40;
	  pcreg_5<=32'h50;
	  pcreg_6<=32'h60;
	  pcreg_7<=32'h70;
	  pcreg_8<=32'h80;
`else
	pcreg <=  ({(except_prefix ? `OR1200_EXCEPT_EPH1_P : `OR1200_EXCEPT_EPH0_P), `OR1200_EXCEPT_RESET, `OR1200_EXCEPT_V} - 1) >> 2;
	pcreg_1 <=  ({(except_prefix ? `OR1200_EXCEPT_EPH1_P : `OR1200_EXCEPT_EPH0_P), `OR1200_EXCEPT_RESET, `OR1200_EXCEPT_V} - 1) >> 2;
	pcreg_2 <=  ({(except_prefix ? `OR1200_EXCEPT_EPH1_P : `OR1200_EXCEPT_EPH0_P), `OR1200_EXCEPT_RESET, `OR1200_EXCEPT_V} - 1) >> 2;
	pcreg_3 <=  ({(except_prefix ? `OR1200_EXCEPT_EPH1_P : `OR1200_EXCEPT_EPH0_P), `OR1200_EXCEPT_RESET, `OR1200_EXCEPT_V} - 1) >> 2;
	pcreg_4 <=  ({(except_prefix ? `OR1200_EXCEPT_EPH1_P : `OR1200_EXCEPT_EPH0_P), `OR1200_EXCEPT_RESET, `OR1200_EXCEPT_V} - 1) >> 2;
	pcreg_5 <=  ({(except_prefix ? `OR1200_EXCEPT_EPH1_P : `OR1200_EXCEPT_EPH0_P), `OR1200_EXCEPT_RESET, `OR1200_EXCEPT_V} - 1) >> 2;
	pcreg_6 <=  ({(except_prefix ? `OR1200_EXCEPT_EPH1_P : `OR1200_EXCEPT_EPH0_P), `OR1200_EXCEPT_RESET, `OR1200_EXCEPT_V} - 1) >> 2;
	pcreg_7 <=  ({(except_prefix ? `OR1200_EXCEPT_EPH1_P : `OR1200_EXCEPT_EPH0_P), `OR1200_EXCEPT_RESET, `OR1200_EXCEPT_V} - 1) >> 2;
	pcreg_8 <=  ({(except_prefix ? `OR1200_EXCEPT_EPH1_P : `OR1200_EXCEPT_EPH0_P), `OR1200_EXCEPT_RESET, `OR1200_EXCEPT_V} - 1) >> 2;
`endif
	end 
	else if (spr_pc_we) begin
	case (temp_thread_out)		// synopsys parallel_case
		3'd0:	pcreg_1 <=  spr_dat_i[31:2];
		3'd1:	pcreg_2 <=  spr_dat_i[31:2];
		3'd2:	pcreg_3 <=  spr_dat_i[31:2];
		3'd3:	pcreg_4 <=  spr_dat_i[31:2];
		3'd4:	pcreg_5 <=  spr_dat_i[31:2];
		3'd5:	pcreg_6 <=  spr_dat_i[31:2];
		3'd6:	pcreg_7 <=  spr_dat_i[31:2];
		3'd7:	pcreg_8 <=  spr_dat_i[31:2];
	endcase
	some_thread = next_thread;
        end
	else if (no_more_dslot | except_start | !genpc_freeze & !icpu_rty_i & !genpc_refetch) begin
	case (temp_thread_out)		// synopsys parallel_case
		3'd0:	pcreg_1 <=  pc[31:2];
		3'd1:	pcreg_2 <=  pc[31:2];
		3'd2:	pcreg_3 <=  pc[31:2];
		3'd3:	pcreg_4 <=  pc[31:2];
		3'd4:	pcreg_5 <=  pc[31:2];
		3'd5:	pcreg_6 <=  pc[31:2];
		3'd6:	pcreg_7 <=  pc[31:2];
		3'd7:	pcreg_8 <=  pc[31:2];
	endcase
	some_thread = next_thread;
	end
endmodule
