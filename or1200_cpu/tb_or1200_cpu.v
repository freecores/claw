`include "timescale.v"
`include "or1200_defines.v"

module tb_or1200_cpu();

parameter dw=32;
parameter aw=5;

reg                           clk;
reg                           rst;
wire                          ic_en;
wire  [31:0]                  icpu_adr_o;
wire                          icpu_cycstb_o;
wire  [3:0]                   icpu_sel_o;
wire  [3:0]                   icpu_tag_o;
reg   [63:0]                  icpu_dat_i;
reg                           icpu_ack_i;
reg                           icpu_rty_i;
reg                           icpu_err_i;
reg   [31:0]                  icpu_adr_i;

wire                          immu_en;

wire  [31:0]                  ex_insn;
wire  [31:0]                  ex_insn2;
wire                          ex_freeze;
wire  [31:0]                  id_pc;
wire  [`OR1200_BRANCHOP_WIDTH-1:0]    branch_op;

reg                           du_stall;
reg   [dw-1:0]                du_addr;
reg   [dw-1:0]                du_dat_du;
reg                           du_read;
reg                           du_write;
reg   [`OR1200_DU_DSR_WIDTH-1:0]      du_dsr;
reg                           du_hwbkpt;
wire  [12:0]                  du_except;
wire  [dw-1:0]                du_dat_cpu;
wire  [dw-1:0]                rf_dataw;
reg [3:0]		      icpu_tag_i;

wire  [31:0]                  dcpu_adr_o;
wire                          dcpu_cycstb_o;
wire                          dcpu_we_o;
wire  [3:0]                   dcpu_sel_o;
wire  [3:0]                   dcpu_tag_o;
wire  [31:0]                  dcpu_dat_o;
wire  [31:0]                  dcpu_adr_o2;
wire                          dcpu_cycstb_o2;
wire                          dcpu_we_o2;
wire  [3:0]                   dcpu_sel_o2;
wire  [3:0]                   dcpu_tag_o2;
wire  [31:0]                  dcpu_dat_o2;
reg   [31:0]                  dcpu_dat_i;
reg                           dcpu_ack_i;
reg                           dcpu_rty_i;
reg                           dcpu_err_i;
reg   [3:0]                   dcpu_tag_i;
wire                          dc_en;

wire                          dmmu_en;
wire                          supv;
reg   [dw-1:0]                spr_dat_pic;
reg   [dw-1:0]                spr_dat_tt;
reg   [dw-1:0]                spr_dat_pm;
reg   [dw-1:0]                spr_dat_dmmu;
reg   [dw-1:0]                spr_dat_immu;
reg   [dw-1:0]                spr_dat_du;
wire  [dw-1:0]                spr_addr;
wire  [dw-1:0]                spr_addr2;
wire  [dw-1:0]                spr_dat_cpu;
wire  [dw-1:0]                spr_dat_npc;

reg                           sig_int;
reg                           sig_tick;
wire [31:0] 			spr_cs;
wire [31:0] 			spr_cs2;
or1200_cpu or1200_cpu(
        // Clk & Rst
        clk, rst,

        // Insn interface
        ic_en,
        icpu_adr_o, icpu_cycstb_o, icpu_sel_o, icpu_tag_o,
        icpu_dat_i, icpu_ack_i, icpu_rty_i, icpu_err_i, icpu_adr_i, icpu_tag_i,
        immu_en,

        // Debug unit
        ex_insn, ex_freeze, id_pc, branch_op,
        ex_insn2,               // bviyer
        spr_dat_npc, rf_dataw,
        du_stall, du_addr, du_dat_du, du_read, du_write, du_dsr, du_hwbkpt,
        du_except, du_dat_cpu,

        // Data interface
        dc_en,
        dcpu_adr_o,dcpu_cycstb_o, dcpu_we_o, dcpu_sel_o, dcpu_tag_o, dcpu_dat_o,
        dcpu_adr_o2,dcpu_cycstb_o2, dcpu_we_o2,
        dcpu_sel_o2, dcpu_tag_o2, dcpu_dat_o2,
        dcpu_dat_i, dcpu_ack_i, dcpu_rty_i, dcpu_err_i, dcpu_tag_i,
        // dcpu_dat_i2,dcpu_ack_i2,dcpu_rty_i2,dcpu_err_i2,dcpu_tag_i2,
        dmmu_en,

        // Interrupt & tick exceptions
        sig_int, sig_tick,

        // SPR interface
        supv, spr_addr, spr_addr2, spr_dat_cpu, spr_dat_pic, spr_dat_tt,
        spr_dat_pm,
        spr_dat_dmmu, spr_dat_immu, spr_dat_du, spr_cs, spr_cs2, spr_we
);

initial begin
  #0 	rst=0;
 	clk=0;
  #5	rst=1;	
  #5	rst=0;
  #10	rst=0;
	du_stall=0;
	icpu_rty_i=0;
	icpu_adr_i=32'b0;
	icpu_dat_i=64'h1500000015000000;
	icpu_ack_i=1'b0;
	icpu_err_i=0;
	// icpu_tag_i=4'b0; // `OR1200_ITAG_PE;
	dcpu_ack_i=1'b1;
	dcpu_err_i=1;
	dcpu_tag_i=4'b0;
	dcpu_dat_i=32'hABCDEF12;
end


always #5 clk = ~clk;
endmodule
