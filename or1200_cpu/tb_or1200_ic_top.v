`define "timescale.v"
`define "or1200_defines.v"

module tb_or1200_ic_top();

reg                           clk;
reg                           rst;
wire  [dw-1:0]                icbiu_dat_o;
wire  [31:0]                  icbiu_adr_o;
wire                          icbiu_cyc_o;
wire                          icbiu_stb_o;
wire                          icbiu_we_o;
wire  [3:0]                   icbiu_sel_o;
wire                          icbiu_cab_o;
reg   [dw-1:0]                icbiu_dat_i;
reg                           icbiu_ack_i;
reg                           icbiu_err_i;
reg                           ic_en;
reg   [31:0]                  icqmem_adr_i;
reg                           icqmem_cycstb_i;
reg                           icqmem_ci_i;
reg   [3:0]                   icqmem_sel_i;
reg   [3:0]                   icqmem_tag_i;
wire  [dw-1:0]                icqmem_dat_o;
wire                          icqmem_ack_o;
wire                          icqmem_rty_o;
wire                          icqmem_err_o;
wire  [3:0]                   icqmem_tag_o;
`ifdef OR1200_BIST
reg mbist_si_i;
reg [`OR1200_MBIST_CTRL_WIDTH - 1:0] mbist_ctrl_i;
wire mbist_so_o;
`endif
reg                           spr_cs;
reg                           spr_write;
reg   [31:0]                  spr_dat_i;


initial begin

#0	rst=0;
	clk=0;
#5	rst=1;

#10	rst=0;
	ic_en=1'b1;
	

