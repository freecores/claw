library verilog;
use verilog.vl_types.all;
entity or1200_gmultp2_32x32 is
    port(
        x               : in     vl_logic_vector(31 downto 0);
        y               : in     vl_logic_vector(31 downto 0);
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        p               : out    vl_logic_vector(63 downto 0)
    );
end or1200_gmultp2_32x32;
