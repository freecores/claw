/********************************************************/
/*                                                      */
/* Basic NCSU Synthesis Script                          */
/*                                                      */
/* Set up for the 0.25um CMOSX library                  */
/*                                                      */
/* Revision History                                     */
/*   1/5/97 : Author P. Franzon                         */
/*   1/2/98 : More heavilly commented                   */
/*   8/8/04 : Modified by Balaji V. Iyer 		*/
/*			(bviyer@ncsu.edu)		*/
/* 		for the OPEN RISC 2 way Multithreading  */
/* 		project					*/
/* 		Advisor: Dr. Tom Conte			*/
/*                                                      */
/********************************************************/
/*//////////////////////////////////////////////////////////////////*/
/*//                                                              //*/
/*// Copyright (C) 2000 Authors and OPENCORES.ORG                 //*/
/*//                                                              //*/
/*// This source file may be used and distributed without         //*/
/*// restriction provided that this copyright statement is not    //*/
/*// removed from the file and that any derivative work contains  //*/
/*// the original copyright notice and the associated disclaimer. //*/
/*//                                                              //*/
/*// This source file is free software; you can redistribute it   //*/
/*// and/or modify it under the terms of the GNU Lesser General   //*/
/*// Public License as published by the Free Software Foundation; //*/
/*// either version 2.1 of the License, or (at your option) any   //*/
/*// later version.                                               //*/
/*//                                                              //*/
/*// This source is distributed in the hope that it will be       //*/
/*// useful, but WITHOUT ANY WARRANTY; without even the implied   //*/
/*// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      //*/
/*// PURPOSE.  See the GNU Lesser General Public License for more //*/
/*// details.                                                     //*/
/*//                                                              //*/
/*// You should have received a copy of the GNU Lesser General    //*/
/*// Public License along with this source; if not, download it   //*/
/*// from http://www.opencores.org/lgpl.shtml                     //*/
/*//                                                              //*/
/*//////////////////////////////////////////////////////////////////*/
/********************************************************/
/*                                                      */
/* Read in Verilog file and map (synthesize)            */
/* onto a generic library                               */
/*                                                      */
/* MAKE SURE THAT YOU CORRECT ALL WARNINGS THAT APPEAR  */
/* during the execution of the read command are fixed   */
/* or understood to have no impact                      */
/*                                                      */
/* ALSO CHECK your latch/flip-flop list for unintended  */
/* latches                                              */
/*                                                      */
/********************************************************/
Read -f Verilog or1200_genpc.v
Read -f Verilog or1200_amultp2_32x32.v
Read -f Verilog or1200_if.v
Read -f Verilog or1200_ctrl.v
Read -f Verilog or1200_alu.v
Read -f Verilog or1200_mult_mac.v
Read -f Verilog or1200_except.v
Read -f Verilog or1200_dpram_32x32.v
Read -f Verilog or1200_rf.v
Read -f Verilog or1200_rf_top.v
Read -f Verilog or1200_mem2reg.v
Read -f Verilog or1200_reg2mem.v
Read -f Verilog or1200_lsu.v
Read -f Verilog or1200_operandmuxes.v
Read -f Verilog or1200_wbmux.v
Read -f Verilog or1200_cfgr.v
Read -f Verilog or1200_freeze.v
Read -f Verilog or1200_sprs.v
Read -f Verilog or1200_cpu.v

current_design = or1200_cpu

/********************************************************/
/*                                                      */
/* Our first Optimization 'compile' is intended to      */
/* produce a design that will meet hold-time            */
/* under worst-case conditions:                         */
/* - slowest process corner                             */
/* - highest operating temperature and lowest Vcc       */
/* - expected worst case clock skew                     */
/*                                                      */
/********************************************************/

/*------------------------------------------------------*/
/* Specify the worst case (slowest) libraries and       */
/* slowest temperature/Vcc conditions                   */
/*------------------------------------------------------*/
link_library = {"ncsulib25_worst.db"}
target_library = {"ncsulib25_worst.db"}
/* set_operating_conditions -library "ms080cmosxCells_XXW" "T125_V4.5" */

/*------------------------------------------------------*/
/* Specify a 250 ns clock period with 50% duty cycle    */
/* and a skew of 1 ns                                   */
/*------------------------------------------------------*/
Create_clock -period 250000 -waveform {0 125000} clk
set_clock_skew  -uncertainty 1000 clk

/*------------------------------------------------------*/
/* Most libraries have bugs in them.                    */
/* This library has cells that don't have a layout version */
/* - the PULLUP cell is one of them                     */
/*------------------------------------------------------*/
/* set_dont_use ms080cmosxCells_XXW/PULLUP */

/********************************************************/
/*                                                      */
/* Now set up the 'CONSTRAINTS' on the design:          */
/* 1.  How much of the clock period is lost in the      */
/*     modules connected to it                          */
/* 2.  What type of cells are driving the inputs        */
/* 3.  What type of cells and how many (fanout) must it */
/*     be able to drive                                 */
/*                                                      */
/********************************************************/

/*------------------------------------------------------*/
/* ASSUME being driven by a slowest D-flip-flop         */
/* The DFF cell has a clock-Q delay of 1.75 ns          */
/* Allow another 0.25 ns for wiring delay               */
/* NOTE: THESE ARE INITIAL ASSUMPTIONS ONLY             */
/*------------------------------------------------------*/
set_input_delay 1100 -clock clk all_inputs() - clk


/*------------------------------------------------------*/
/* ASSUME this module is driving a D-flip-flip          */
/* The DFF cell has a set-up time of 1.4 ns             */
/* Allow another 0.25 ns for wiring delay               */
/* NOTE: THESE ARE INITIAL ASSUMPTIONS ONLY             */
/*------------------------------------------------------*/
set_output_delay 950 -clock clk all_outputs()

/*------------------------------------------------------*/
/* ASSUME being driven by a D-flip-flop                 */
/*------------------------------------------------------*/
set_driving_cell -no_design_rule -cell "dp_2" -pin "q" all_inputs() - clk

/*------------------------------------------------------*/
/* ASSUME the woest case output load is                 */
/* 3 D-flip-flop (D-inputs) and                         */
/* and 0.5 units of wiring capacitance                  */
/*------------------------------------------------------*/
port_load = 0.5 + 3 *  load_of (ncsulib25_worst/dp_2/ip)
set_load port_load all_outputs()

/********************************************************/
/*                                                      */
/* Now set the GOALS for the compile                    */
/*                                                      */
/* In most cases you want minimum area, so set the      */
/* goal for maximum area to be 0                        */
/*                                                      */
/********************************************************/
set_max_area 0
link
uniquify

/*------------------------------------------------------*/
/* During the initial map (synthesis), Synopsys might   */
/* have built parts (such as adders) using its          */
/* DesignWare(TM) library.  In order to remap the       */
/* design to our CMOSX library AND to create scope      */
/* for logic reduction, I want to 'flatten out' the     */
/* DesignWare components.  i.e. Make one flat design    */
/*                                                      */
/* 'replace_synthetic' is the cleanest way of doing this*/
/*------------------------------------------------------*/
replace_synthetic -ungroup

/*------------------------------------------------------*/
/* check the design before otimization                  */
/*------------------------------------------------------*/
check_design
check_timing

/********************************************************/
/*                                                      */
/* Now resynthesize the design to meet constraints,     */
/* and try to best achieve the goal, and using the      */
/* CMOSX parts.  In large designs, compile can take     */
/* a lllooonnnnggg  time                                */
/*                                                      */
/********************************************************/

/*------------------------------------------------------*/
/* -map_effort specifies how much optimization effort   */
/*      there is low, medium, and high                  */
/*      use high to squeeze out those last picoseconds  */
/* -verify_effort specifies how much effort to spend    */
/*      making sure that the input and output designs   */
/*      are equivalent logically                        */
/*------------------------------------------------------*/
compile -map_effort high  /* -verify -verify_effort medium */

/*------------------------------------------------------*/
/* Now trace the critical (slowest) path and see if     */
/* the timing works.                                    */
/*                                                      */
/* If the slack is NOT met, you HAVE A PROBLEM and      */
/* need to redesign or try some other minimization      */
/* tricks that Synopsys can do                          */
/*------------------------------------------------------*/
report_timing 
report_area
/********************************************************/
/*                                                      */
/* This is your section to do different things to       */
/* improve timing or area - RTFM                        */
/*                                                      */
/********************************************************/

/********************************************************/
/*                                                      */
/* Now resynthesize the design for the fastest corner   */
/* making sure that hold time conditions are met        */
/*                                                      */
/********************************************************/

/*------------------------------------------------------*/
/* Specify the fastest process corner and lowest temp   */
/* And highest (fastest) Vcc                            */
/*------------------------------------------------------*/
/* link_library = {"ms080cmosxCells_XXB.db"} */
/* target_library = {"ms080cmosxCells_XXB.db"} */
/* set_operating_conditions -library "ms080cmosxCells_XXB" "T-55_V5.5" */
/*------------------------------------------------------*/
/* Since we have a 'new' library, we need to do this    */
/* again                                                */
/*------------------------------------------------------*/
/* set_dont_use ms080cmosxCells_XXB/PULLUP */

/*------------------------------------------------------*/
/* Set the design rule to 'fix hold time violations'    */
/* Then compile the design again, telling Synopsys to   */
/* Only change the design if there are hold time        */
/* violations.                                          */
/*------------------------------------------------------*/
/* set_fix_hold clk */
/* compile -only_design_rule -incremental */

/*------------------------------------------------------*/
/* Report the fastest path.  Make sure the hold         */
/* is actually met.                                     */
/*------------------------------------------------------*/
/* report_timing -delay min */
 
/*------------------------------------------------------*/
/* Write out the 'fastest' (minimum) timing file        */
/* in Standard Delay Format.  We might use this in later*/
/* verification.                                        */
/*------------------------------------------------------*/
/* write_timing -output or1200_rf_top_min.sdf -format sdf */

/*------------------------------------------------------*/
/* Since Synopsys has to insert logic to meet hold      */
/* violations, we might find that we have setup         */
/* violations now.  SO lets recheck with the slowest    */
/* corner etc.                                          */
/*                                                      */ 
/*  YOU problems if the slack is NOT MET                */
/*                                                      */ 
/* 'translate' means 'translate to new library'         */
/*------------------------------------------------------*/

/* link_library = {"ms080cmosxCells_XXB.db"} */
/* target_library = {"ms080cmosxCells_XXW.db"} */
/* set_operating_conditions -library "ms080cmosxCells_XXW" "T125_V4.5" */
/* translate */
/* report_timing */

/*------------------------------------------------------*/
/* Write out the resulting netlist in Verliog format    */
/*------------------------------------------------------*/
/* write -f verilog -o or1200_rf_top_final.v */

/*------------------------------------------------------*/
/* Write out the 'slowest' (maximum) timing file        */
/* in Standard Delay Format.  We might use this in later*/
/* verification.                                        */
/*------------------------------------------------------*/
/* write_timing -output or1200_rf_top_max.sdf -format sdf */
