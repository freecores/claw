library verilog;
use verilog.vl_types.all;
entity or1200_mult_mac is
    generic(
        width           : integer := 32
    );
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        ex_freeze       : in     vl_logic;
        id_macrc_op     : in     vl_logic;
        macrc_op        : in     vl_logic;
        a               : in     vl_logic_vector;
        b               : in     vl_logic_vector;
        mac_op          : in     vl_logic_vector(1 downto 0);
        alu_op          : in     vl_logic_vector(3 downto 0);
        result          : out    vl_logic_vector;
        mac_stall_r     : out    vl_logic;
        spr_cs          : in     vl_logic;
        spr_write       : in     vl_logic;
        spr_addr        : in     vl_logic_vector(31 downto 0);
        spr_dat_i       : in     vl_logic_vector(31 downto 0);
        spr_dat_o       : out    vl_logic_vector(31 downto 0);
        thread_in       : in     vl_logic_vector(2 downto 0);
        thread_out      : out    vl_logic_vector(2 downto 0)
    );
end or1200_mult_mac;
