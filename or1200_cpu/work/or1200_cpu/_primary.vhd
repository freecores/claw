library verilog;
use verilog.vl_types.all;
entity or1200_cpu is
    generic(
        dw              : integer := 32;
        aw              : integer := 5
    );
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        ic_en           : out    vl_logic;
        icpu_adr_o      : out    vl_logic_vector(31 downto 0);
        icpu_cycstb_o   : out    vl_logic;
        icpu_sel_o      : out    vl_logic_vector(3 downto 0);
        icpu_tag_o      : out    vl_logic_vector(3 downto 0);
        icpu_dat_i      : in     vl_logic_vector(63 downto 0);
        icpu_ack_i      : in     vl_logic;
        icpu_rty_i      : in     vl_logic;
        icpu_err_i      : in     vl_logic;
        icpu_adr_i      : in     vl_logic_vector(31 downto 0);
        icpu_tag_i      : in     vl_logic_vector(3 downto 0);
        immu_en         : out    vl_logic;
        ex_insn         : out    vl_logic_vector(31 downto 0);
        ex_freeze       : out    vl_logic;
        id_pc           : out    vl_logic_vector(31 downto 0);
        branch_op       : out    vl_logic_vector(2 downto 0);
        ex_insn2        : out    vl_logic_vector(31 downto 0);
        spr_dat_npc     : out    vl_logic_vector(31 downto 0);
        rf_dataw        : out    vl_logic_vector;
        du_stall        : in     vl_logic;
        du_addr         : in     vl_logic_vector;
        du_dat_du       : in     vl_logic_vector;
        du_read         : in     vl_logic;
        du_write        : in     vl_logic;
        du_dsr          : in     vl_logic_vector(13 downto 0);
        du_hwbkpt       : in     vl_logic;
        du_except       : out    vl_logic_vector(12 downto 0);
        du_dat_cpu      : out    vl_logic_vector;
        dc_en           : out    vl_logic;
        dcpu_adr_o      : out    vl_logic_vector(31 downto 0);
        dcpu_cycstb_o   : out    vl_logic;
        dcpu_we_o       : out    vl_logic;
        dcpu_sel_o      : out    vl_logic_vector(3 downto 0);
        dcpu_tag_o      : out    vl_logic_vector(3 downto 0);
        dcpu_dat_o      : out    vl_logic_vector(31 downto 0);
        dcpu_adr_o2     : out    vl_logic_vector(31 downto 0);
        dcpu_cycstb_o2  : out    vl_logic;
        dcpu_we_o2      : out    vl_logic;
        dcpu_sel_o2     : out    vl_logic_vector(3 downto 0);
        dcpu_tag_o2     : out    vl_logic_vector(3 downto 0);
        dcpu_dat_o2     : out    vl_logic_vector(31 downto 0);
        dcpu_dat_i      : in     vl_logic_vector(31 downto 0);
        dcpu_ack_i      : in     vl_logic;
        dcpu_rty_i      : in     vl_logic;
        dcpu_err_i      : in     vl_logic;
        dcpu_tag_i      : in     vl_logic_vector(3 downto 0);
        dmmu_en         : out    vl_logic;
        sig_int         : in     vl_logic;
        sig_tick        : in     vl_logic;
        supv            : out    vl_logic;
        spr_addr        : out    vl_logic_vector;
        spr_addr2       : out    vl_logic_vector;
        spr_dat_cpu     : out    vl_logic_vector;
        spr_dat_pic     : in     vl_logic_vector;
        spr_dat_tt      : in     vl_logic_vector;
        spr_dat_pm      : in     vl_logic_vector;
        spr_dat_dmmu    : in     vl_logic_vector;
        spr_dat_immu    : in     vl_logic_vector;
        spr_dat_du      : in     vl_logic_vector;
        spr_cs          : out    vl_logic_vector;
        spr_cs2         : out    vl_logic_vector;
        spr_we          : out    vl_logic
    );
end or1200_cpu;
