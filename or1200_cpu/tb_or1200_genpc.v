`include "timescale.v"
`include "or1200_defines.v"

module tb_or1200_genpc();
reg                           clk;
reg                           rst;
wire  [31:0]                  icpu_adr_o;
wire                          icpu_cycstb_o;
wire  [3:0]                   icpu_sel_o;
wire  [3:0]                   icpu_tag_o;
reg                           icpu_rty_i;
reg   [31:0]                  icpu_adr_i;
reg   [`OR1200_BRANCHOP_WIDTH-1:0]    branch_op;
reg   [`OR1200_EXCEPT_WIDTH-1:0]      except_type;
reg                                   except_prefix;
reg   [31:2]                  branch_addrofs;
reg   [31:0]                  lr_restor;
reg                           flag;
wire                          taken;
reg                           except_start;
reg   [31:2]                  binsn_addr;
reg   [31:0]                  epcr;
reg   [31:0]                  spr_dat_i;
reg                           spr_pc_we;
reg                           genpc_refetch;
reg                           genpc_stop_prefetch;
reg                           genpc_freeze;
reg                           no_more_dslot;
reg [2:0]                     branch_thread;  
reg [2:0]                     except_thread;  
reg [2:0]                     wb_thread;      
wire [2:0]                    thread_out;   




or1200_genpc or1200_genpc(
        clk, rst,
        icpu_adr_o, icpu_cycstb_o, icpu_sel_o, icpu_tag_o,
        icpu_rty_i, icpu_adr_i,
        branch_op, except_type, except_prefix,
        branch_addrofs, lr_restor, flag, taken, except_start,
        binsn_addr, epcr, spr_dat_i, spr_pc_we, genpc_refetch,
        genpc_freeze, genpc_stop_prefetch, no_more_dslot,
        thread_out, branch_thread,wb_thread, except_thread
);

initial begin

#0	rst=0;
	clk=1;
#5	rst=1;

#10	rst=0;
	no_more_dslot=0;
	except_start=0;
	icpu_rty_i=0;
	genpc_refetch=0;
	genpc_freeze=0;
	spr_pc_we=0;
	branch_op=`OR1200_BRANCHOP_NOP;
/*
#10	rst=0;
	except_start=0;
	spr_pc_we=0;
	branch_op=`OR1200_BRANCHOP_NOP;
*/

#60	except_start=0;
	spr_pc_we=0;
	branch_op=`OR1200_BRANCHOP_J;
	branch_addrofs=30'b11_1111_1111_1111_1111_1111_1111_1111;
	branch_thread=3'd5;

#10	except_start=0;
	spr_pc_we=0;
	branch_op=`OR1200_BRANCHOP_JR;
	lr_restor=32'hF0F0F0F0;
	branch_thread=3'd3;

#10	except_start=0;
	spr_pc_we=0;
	branch_op=`OR1200_BRANCHOP_BAL;
	binsn_addr=30'd3;
	branch_addrofs=30'd6;
	wb_thread=3'd2;
end

always #5 clk = ~clk;
endmodule
		

