library verilog;
use verilog.vl_types.all;
entity or1200_sprs is
    generic(
        width           : integer := 32
    );
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        flagforw        : in     vl_logic;
        flag_we         : in     vl_logic;
        flag            : out    vl_logic;
        cyforw          : in     vl_logic;
        cy_we           : in     vl_logic;
        carry           : out    vl_logic;
        addrbase        : in     vl_logic_vector;
        addrofs         : in     vl_logic_vector(15 downto 0);
        dat_i           : in     vl_logic_vector;
        alu_op          : in     vl_logic_vector(3 downto 0);
        branch_op       : in     vl_logic_vector(2 downto 0);
        epcr            : in     vl_logic_vector;
        eear            : in     vl_logic_vector;
        esr             : in     vl_logic_vector(15 downto 0);
        except_started  : in     vl_logic;
        to_wbmux        : out    vl_logic_vector;
        epcr_we         : out    vl_logic;
        eear_we         : out    vl_logic;
        esr_we          : out    vl_logic;
        pc_we           : out    vl_logic;
        sr_we           : out    vl_logic;
        to_sr           : out    vl_logic_vector(15 downto 0);
        sr              : out    vl_logic_vector(15 downto 0);
        spr_dat_cfgr    : in     vl_logic_vector(31 downto 0);
        spr_dat_rf      : in     vl_logic_vector(31 downto 0);
        spr_dat_npc     : in     vl_logic_vector(31 downto 0);
        spr_dat_ppc     : in     vl_logic_vector(31 downto 0);
        spr_dat_mac     : in     vl_logic_vector(31 downto 0);
        spr_dat_cfgr2   : in     vl_logic_vector(31 downto 0);
        spr_dat_pic     : in     vl_logic_vector(31 downto 0);
        spr_dat_tt      : in     vl_logic_vector(31 downto 0);
        spr_dat_pm      : in     vl_logic_vector(31 downto 0);
        spr_dat_dmmu    : in     vl_logic_vector(31 downto 0);
        spr_dat_immu    : in     vl_logic_vector(31 downto 0);
        spr_dat_du      : in     vl_logic_vector(31 downto 0);
        spr_addr        : out    vl_logic_vector(31 downto 0);
        spr_addr2       : out    vl_logic_vector(31 downto 0);
        spr_dat_o       : out    vl_logic_vector(31 downto 0);
        spr_cs          : out    vl_logic_vector(31 downto 0);
        spr_we          : out    vl_logic;
        du_addr         : in     vl_logic_vector;
        du_dat_du       : in     vl_logic_vector;
        du_read         : in     vl_logic;
        du_write        : in     vl_logic;
        du_dat_cpu      : out    vl_logic_vector;
        thread_in       : in     vl_logic_vector(2 downto 0);
        thread_out      : out    vl_logic_vector(2 downto 0)
    );
end or1200_sprs;
