//////////////////////////////////////////////////////////////////////
////  OR1200's correct register file chooser                      ////
////                                                              ////
////                                                              ////
////  Description                                                 ////
////   Chooses the appropriate register to write and read         ////
////                                                              ////
////  Written by:						  ////
////      - Balaji V. Iyer, bviyer@ncsu.edu			  ////
////  Advisor:							  ////
////      - Dr. Tom Conte					  ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright (C) 2004 Authors and OPENCORES.ORG                 ////
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

// synopsys translate_off
`include "timescale.v"
// synopsys translate_on
`include "or1200_defines.v"

module or1200_rf_top(
	// Clock and reset
	clk, rst,

	// Write i/f
	supv, wb_freeze, addrw, dataw, addrw2, dataw2, we, we2, flushpipe,
		
	// Read i/f
	id_freeze, addra, addrb, dataa, datab, rda, rdb,
	           addra2,addrb2, dataa2, datab2, rda2, rdb2,

	// Debug
	spr_cs, spr_write, spr_addr, spr_dat_i, spr_dat_o,
	current_thread_read, current_thread_read_out, 
	current_thread_write
);

parameter dw = 32; //`OR1200_OPERAND_WIDTH;
parameter aw = 5; // `OR1200_REGFILE_ADDR_WIDTH;

//
// I/O
//

//
// Clock and reset
//
input				clk;
input				rst;

//
// Write i/f
//
input				supv;
input				wb_freeze;
input	[aw-1:0]		addrw;
input	[dw-1:0]		dataw;
input				we;
input				flushpipe;


//bviyer: this is used to hold the thread

input [2:0]		current_thread_read;
output [2:0]		current_thread_read_out;
reg [2:0]		current_thread_read_out;
input [2:0]		current_thread_write;

// bviyer: replicated the write port to two. One problem here we can face is that
// if two insturctions write the same register then we will have some biggie
// problems...but this is something that the compiler should take care of it. 
input [aw-1:0]			addrw2;
input [dw-1:0]			dataw2;
input				we2;
//
// Read i/f
//
input				id_freeze;
input	[aw-1:0]		addra;
input	[aw-1:0]		addrb;
output	[dw-1:0]		dataa;
reg     [dw-1:0]		dataa;
output	[dw-1:0]		datab;
reg	[dw-1:0]		datab;
input				rda;
input				rdb;

// bviyer: replicated the address and output ports to hold two values to the register file.

input [aw-1:0]			addra2;
input [aw-1:0]			addrb2;
output [dw-1:0]			dataa2;
reg    [dw-1:0]			dataa2;
output [dw-1:0]			datab2;
reg    [dw-1:0]			datab2;
input 				rda2;
input				rdb2;	



//
// SPR access for debugging purposes
//
input				spr_cs;
input				spr_write;
input	[31:0]			spr_addr;
input	[31:0]			spr_dat_i;
output	[31:0]			spr_dat_o;
reg	[31:0]			spr_dat_o;

//
// Internal wires and regs
//

wire[31:0] spr_dat_o_1;
wire[31:0] spr_dat_o_2;
wire[31:0] spr_dat_o_3;
wire[31:0] spr_dat_o_4;
wire[31:0] spr_dat_o_5;
wire[31:0] spr_dat_o_6;
wire[31:0] spr_dat_o_7;
wire[31:0] spr_dat_o_8;


// to hold different register A data of slot 1 
wire[31:0] dataa_1;
wire[31:0] dataa_2;
wire[31:0] dataa_3;
wire[31:0] dataa_4;
wire[31:0] dataa_5;
wire[31:0] dataa_6;
wire[31:0] dataa_7;
wire[31:0] dataa_8;

// to hold different register A data of slot 2
wire[31:0] dataa2_1;
wire[31:0] dataa2_2;
wire[31:0] dataa2_3;
wire[31:0] dataa2_4;
wire[31:0] dataa2_5;
wire[31:0] dataa2_6;
wire[31:0] dataa2_7;
wire[31:0] dataa2_8;

// to hold different register B data of slot 1
wire[31:0] datab_1;
wire[31:0] datab_2;
wire[31:0] datab_3;
wire[31:0] datab_4;
wire[31:0] datab_5;
wire[31:0] datab_6;
wire[31:0] datab_7;
wire[31:0] datab_8;


// to hold different register B data of slot 1
wire[31:0] datab2_1;
wire[31:0] datab2_2;
wire[31:0] datab2_3;
wire[31:0] datab2_4;
wire[31:0] datab2_5;
wire[31:0] datab2_6;
wire[31:0] datab2_7;
wire[31:0] datab2_8;

//differnt write enables to make sure we are not writing to every register
// just the ones we want.

wire we_1;
wire we_2;
wire we_3;
wire we_4;
wire we_5;
wire we_6;
wire we_7;
wire we_8;

// same for the write port two

wire we2_1;
wire we2_2;
wire we2_3;
wire we2_4;
wire we2_5;
wire we2_6;
wire we2_7;
wire we2_8;


// assigning the correct write enable
assign we_1 = we & (!current_thread_write[0] & !current_thread_write[1] 
	& !current_thread_write[2]);
assign we_2 = we & (current_thread_write[0]  & !current_thread_write[1] &
	!current_thread_write[2]);
assign we_3 = we & (!current_thread_write[0] &  current_thread_write[1] &
        !current_thread_write[2]);
assign we_4 = we & (current_thread_write[0]  &  current_thread_write[1] &
	!current_thread_write[2]);
assign we_5 = we & (!current_thread_write[0] & !current_thread_write[1] &
	current_thread_write[2]);
assign we_6 = we & (current_thread_write[0]  & !current_thread_write[1] &
 	current_thread_write[2]);
assign we_7 = we & (!current_thread_write[0] &  current_thread_write[1] &
	current_thread_write[2]);
assign we_8 = we & (current_thread_write[0]  &  current_thread_write[1] &
	current_thread_write[2]);

assign we2_1 = we2 & (!current_thread_write[0] & !current_thread_write[1] 
	& !current_thread_write[2]);
assign we2_2 = we2 & (current_thread_write[0]  & !current_thread_write[1] &
	!current_thread_write[2]);
assign we2_3 = we2 & (!current_thread_write[0] &  current_thread_write[1] &
        !current_thread_write[2]);
assign we2_4 = we2 & (current_thread_write[0]  &  current_thread_write[1] &
	!current_thread_write[2]);
assign we2_5 = we2 & (!current_thread_write[0] & !current_thread_write[1] &
	current_thread_write[2]);
assign we2_6 = we2 & (current_thread_write[0]  & !current_thread_write[1] &
 	current_thread_write[2]);
assign we2_7 = we2 & (!current_thread_write[0] &  current_thread_write[1] &
	current_thread_write[2]);
assign we2_8 = we2 & (current_thread_write[0]  &  current_thread_write[1] &
	current_thread_write[2]);
 
or1200_rf or1200_rf1(.clk(clk), .rst(rst), .supv(supv), .wb_freeze(wb_freeze),
  .addrw(addrw), .dataw(dataw), .addrw2(addrw2), .dataw2(dataw2), .we(we_1),
  .we2(we2_1), .flushpipe (flushpipe), .id_freeze(id_freeze), .addra(addra),
  .addrb(addrb), .dataa(dataa_1), .datab(datab_1), .rda(rda), .rdb(rdb),
  .addra2(addra2), .addrb2(addrb2), .dataa2(dataa2_1),
  .datab2(datab2_1), .rda2(rda2), .rdb2(rdb2), .spr_cs(spr_cs),
  .spr_write(spr_write), .spr_addr(spr_addr), .spr_dat_i(spr_dat_i),
  .spr_dat_o(spr_dat_o_1));

or1200_rf or1200_rf2(.clk(clk), .rst(rst), .supv(supv), .wb_freeze(wb_freeze),
  .addrw(addrw), .dataw(dataw), .addrw2(addrw2), .dataw2(dataw2), .we(we_2),
  .we2(we2_2), .flushpipe (flushpipe), .id_freeze(id_freeze), .addra(addra),
  .addrb(addrb), .dataa(dataa_2), .datab(datab_2), .rda(rda), .rdb(rdb),
  .addra2(addra2), .addrb2(addrb2), .dataa2(dataa2_2),
  .datab2(datab2_2), .rda2(rda2), .rdb2(rdb2), .spr_cs(spr_cs),
  .spr_write(spr_write), .spr_addr(spr_addr), .spr_dat_i(spr_dat_i),
  .spr_dat_o(spr_dat_o_2));

or1200_rf or1200_rf3(.clk(clk), .rst(rst), .supv(supv), .wb_freeze(wb_freeze),
  .addrw(addrw), .dataw(dataw), .addrw2(addrw2), .dataw2(dataw2), .we(we_3),
  .we2(we2_3), .flushpipe (flushpipe), .id_freeze(id_freeze), .addra(addra),
  .addrb(addrb), .dataa(dataa_3), .datab(datab_3), .rda(rda), .rdb(rdb),
  .addra2(addra2), .addrb2(addrb2), .dataa2(dataa2_3),
  .datab2(datab2_3), .rda2(rda2), .rdb2(rdb2), .spr_cs(spr_cs),
  .spr_write(spr_write), .spr_addr(spr_addr), .spr_dat_i(spr_dat_i),
  .spr_dat_o(spr_dat_o_3));

or1200_rf or1200_rf4(.clk(clk), .rst(rst), .supv(supv), .wb_freeze(wb_freeze),
  .addrw(addrw), .dataw(dataw), .addrw2(addrw2), .dataw2(dataw2), .we(we_4),
  .we2(we2_4), .flushpipe (flushpipe), .id_freeze(id_freeze), .addra(addra),
  .addrb(addrb), .dataa(dataa_4), .datab(datab_4), .rda(rda), .rdb(rdb),
  .addra2(addra2), .addrb2(addrb2), .dataa2(dataa2_4),
  .datab2(datab2_4), .rda2(rda2), .rdb2(rdb2), .spr_cs(spr_cs),
  .spr_write(spr_write), .spr_addr(spr_addr), .spr_dat_i(spr_dat_i),
  .spr_dat_o(spr_dat_o_4));

or1200_rf or1200_rf5(.clk(clk), .rst(rst), .supv(supv), .wb_freeze(wb_freeze),
  .addrw(addrw), .dataw(dataw), .addrw2(addrw2), .dataw2(dataw2), .we(we_5),
  .we2(we2_5), .flushpipe (flushpipe), .id_freeze(id_freeze), .addra(addra),
  .addrb(addrb), .dataa(dataa_5), .datab(datab_5), .rda(rda), .rdb(rdb),
  .addra2(addra2), .addrb2(addrb2), .dataa2(dataa2_5),
  .datab2(datab2_5), .rda2(rda2), .rdb2(rdb2), .spr_cs(spr_cs),
  .spr_write(spr_write), .spr_addr(spr_addr), .spr_dat_i(spr_dat_i),
  .spr_dat_o(spr_dat_o_5));

or1200_rf or1200_rf6(.clk(clk), .rst(rst), .supv(supv), .wb_freeze(wb_freeze),
  .addrw(addrw), .dataw(dataw), .addrw2(addrw2), .dataw2(dataw2), .we(we_6),
  .we2(we2_6), .flushpipe (flushpipe), .id_freeze(id_freeze), .addra(addra),
  .addrb(addrb), .dataa(dataa_6), .datab(datab_6), .rda(rda), .rdb(rdb),
  .addra2(addra2), .addrb2(addrb2), .dataa2(dataa2_6),
  .datab2(datab2_6), .rda2(rda2), .rdb2(rdb2), .spr_cs(spr_cs),
  .spr_write(spr_write), .spr_addr(spr_addr), .spr_dat_i(spr_dat_i),
  .spr_dat_o(spr_dat_o_6));

or1200_rf or1200_rf7(.clk(clk), .rst(rst), .supv(supv), .wb_freeze(wb_freeze),
  .addrw(addrw), .dataw(dataw), .addrw2(addrw2), .dataw2(dataw2), .we(we_7),
  .we2(we2_7), .flushpipe (flushpipe), .id_freeze(id_freeze), .addra(addra),
  .addrb(addrb), .dataa(dataa_7), .datab(datab_7), .rda(rda), .rdb(rdb),
  .addra2(addra2), .addrb2(addrb2), .dataa2(dataa2_7),
  .datab2(datab2_7), .rda2(rda2), .rdb2(rdb2), .spr_cs(spr_cs),
  .spr_write(spr_write), .spr_addr(spr_addr), .spr_dat_i(spr_dat_i),
  .spr_dat_o(spr_dat_o_7));

or1200_rf or1200_rf8(.clk(clk), .rst(rst), .supv(supv), .wb_freeze(wb_freeze),
  .addrw(addrw), .dataw(dataw), .addrw2(addrw2), .dataw2(dataw2), .we(we_8),
  .we2(we2_8), .flushpipe (flushpipe), .id_freeze(id_freeze), .addra(addra),
  .addrb(addrb), .dataa(dataa_8), .datab(datab_8), .rda(rda), .rdb(rdb),
  .addra2(addra2), .addrb2(addrb2), .dataa2(dataa2_8),
  .datab2(datab2_8), .rda2(rda2), .rdb2(rdb2), .spr_cs(spr_cs),
  .spr_write(spr_write), .spr_addr(spr_addr), .spr_dat_i(spr_dat_i),
  .spr_dat_o(spr_dat_o_8));

always @ (datab_1 or datab_2 or datab_3 or datab_4 or
	  datab_5 or datab_6 or datab_7 or datab_8 or
	  dataa_1 or dataa_2 or dataa_3 or dataa_4 or
	  dataa_5 or dataa_6 or dataa_7 or dataa_8 or
	  datab2_1 or datab2_2 or datab2_3 or datab2_4 or
  	  datab2_5 or datab2_6 or datab2_7 or datab2_8 or
	  dataa2_1 or dataa2_2 or dataa2_3 or dataa2_4 or
  	  dataa2_5 or dataa2_6 or dataa2_7 or dataa2_8 or
	  spr_dat_o_1 or spr_dat_o_2 or spr_dat_o_3 or spr_dat_o_4 or
  	  spr_dat_o_5 or spr_dat_o_6 or spr_dat_o_7 or spr_dat_o_8 or
  	  current_thread_read)
begin
	// current_thread_read_out <= current_thread_read;
   case (current_thread_read)		// synopsys parallel_case
	3'd0: begin
	  	dataa  <= dataa_1;	
	  	datab  <= datab_1;	
		dataa2 <= dataa2_1;
		datab2 <= datab2_1;
		spr_dat_o <= spr_dat_o_1;
      		current_thread_read_out <= 3'd0; 
		end
	3'd1: begin
	  	dataa  <= dataa_2;	
	  	datab  <= datab_2;	
		dataa2 <= dataa2_2;
		datab2 <= datab2_2;
		spr_dat_o <= spr_dat_o_2;
      		current_thread_read_out <= 3'd1; 
		end
	3'd2: begin
	  	dataa  <= dataa_3;	
	  	datab  <= datab_3;	
		dataa2 <= dataa2_3;
		datab2 <= datab2_3;
		spr_dat_o <= spr_dat_o_3;
      		current_thread_read_out <= 3'd2; 
		end
	3'd3: begin
	  	dataa  <= dataa_4;	
	  	datab  <= datab_4;	
		dataa2 <= dataa2_4;
		datab2 <= datab2_4;
		spr_dat_o <= spr_dat_o_4;
      		current_thread_read_out <= 3'd3; 
		end
	3'd4: begin
	  	dataa  <= dataa_5;	
	  	datab  <= datab_5;	
		dataa2 <= dataa2_5;
		datab2 <= datab2_5;
		spr_dat_o <= spr_dat_o_5;
      		current_thread_read_out <= 3'd4; 
		end
	3'd5: begin
	  	dataa  <= dataa_6;	
	  	datab  <= datab_6;	
		dataa2 <= dataa2_6;
		datab2 <= datab2_6;
		spr_dat_o <= spr_dat_o_6;
      		current_thread_read_out <= 3'd5;
		end
	3'd6: begin
	  	dataa  <= dataa_7;	
	  	datab  <= datab_7;	
		dataa2 <= dataa2_7;
		datab2 <= datab2_7;
		spr_dat_o <= spr_dat_o_7;
      		current_thread_read_out <= 3'd6; 
		end
	3'd7: begin
	  	dataa  <= dataa_8;	
	  	datab  <= datab_8;	
		dataa2 <= dataa2_8;
		datab2 <= datab2_8;
		spr_dat_o <= spr_dat_o_8;
      		current_thread_read_out <= 3'd7;
		end
   endcase
end 
endmodule
