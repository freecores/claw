library verilog;
use verilog.vl_types.all;
entity or1200_sb is
    generic(
        dw              : integer := 64;
        aw              : integer := 64
    );
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        dcsb_dat_i      : in     vl_logic_vector;
        dcsb_adr_i      : in     vl_logic_vector;
        dcsb_cyc_i      : in     vl_logic;
        dcsb_stb_i      : in     vl_logic;
        dcsb_we_i       : in     vl_logic;
        dcsb_sel_i      : in     vl_logic_vector(3 downto 0);
        dcsb_cab_i      : in     vl_logic;
        dcsb_dat_o      : out    vl_logic_vector;
        dcsb_ack_o      : out    vl_logic;
        dcsb_err_o      : out    vl_logic;
        sbbiu_dat_o     : out    vl_logic_vector;
        sbbiu_adr_o     : out    vl_logic_vector;
        sbbiu_cyc_o     : out    vl_logic;
        sbbiu_stb_o     : out    vl_logic;
        sbbiu_we_o      : out    vl_logic;
        sbbiu_sel_o     : out    vl_logic_vector(3 downto 0);
        sbbiu_cab_o     : out    vl_logic;
        sbbiu_dat_i     : in     vl_logic_vector;
        sbbiu_ack_i     : in     vl_logic;
        sbbiu_err_i     : in     vl_logic
    );
end or1200_sb;
