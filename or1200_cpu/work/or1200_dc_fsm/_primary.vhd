library verilog;
use verilog.vl_types.all;
entity or1200_dc_fsm is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        dc_en           : in     vl_logic;
        dcqmem_cycstb_i : in     vl_logic;
        dcqmem_ci_i     : in     vl_logic;
        dcqmem_we_i     : in     vl_logic;
        dcqmem_sel_i    : in     vl_logic_vector(3 downto 0);
        tagcomp_miss    : in     vl_logic;
        biudata_valid   : in     vl_logic;
        biudata_error   : in     vl_logic;
        start_addr      : in     vl_logic_vector(31 downto 0);
        saved_addr      : out    vl_logic_vector(31 downto 0);
        dcram_we        : out    vl_logic_vector(3 downto 0);
        biu_read        : out    vl_logic;
        biu_write       : out    vl_logic;
        first_hit_ack   : out    vl_logic;
        first_miss_ack  : out    vl_logic;
        first_miss_err  : out    vl_logic;
        burst           : out    vl_logic;
        tag_we          : out    vl_logic;
        dc_addr         : out    vl_logic_vector(31 downto 0)
    );
end or1200_dc_fsm;
