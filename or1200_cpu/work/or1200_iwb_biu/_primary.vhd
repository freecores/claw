library verilog;
use verilog.vl_types.all;
entity or1200_iwb_biu is
    generic(
        dw              : integer := 64;
        aw              : integer := 64
    );
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        clmode          : in     vl_logic_vector(1 downto 0);
        wb_clk_i        : in     vl_logic;
        wb_rst_i        : in     vl_logic;
        wb_ack_i        : in     vl_logic;
        wb_err_i        : in     vl_logic;
        wb_rty_i        : in     vl_logic;
        wb_dat_i        : in     vl_logic_vector;
        wb_cyc_o        : out    vl_logic;
        wb_adr_o        : out    vl_logic_vector;
        wb_stb_o        : out    vl_logic;
        wb_we_o         : out    vl_logic;
        wb_sel_o        : out    vl_logic_vector(3 downto 0);
        wb_dat_o        : out    vl_logic_vector;
        wb_cab_o        : out    vl_logic;
        biu_dat_i       : in     vl_logic_vector;
        biu_adr_i       : in     vl_logic_vector;
        biu_cyc_i       : in     vl_logic;
        biu_stb_i       : in     vl_logic;
        biu_we_i        : in     vl_logic;
        biu_sel_i       : in     vl_logic_vector(3 downto 0);
        biu_cab_i       : in     vl_logic;
        biu_dat_o       : out    vl_logic_vector(31 downto 0);
        biu_ack_o       : out    vl_logic;
        biu_err_o       : out    vl_logic
    );
end or1200_iwb_biu;
