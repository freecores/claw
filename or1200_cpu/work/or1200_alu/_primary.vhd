library verilog;
use verilog.vl_types.all;
entity or1200_alu is
    generic(
        width           : integer := 32
    );
    port(
        a               : in     vl_logic_vector;
        b               : in     vl_logic_vector;
        mult_mac_result : in     vl_logic_vector;
        macrc_op        : in     vl_logic;
        alu_op          : in     vl_logic_vector(3 downto 0);
        shrot_op        : in     vl_logic_vector(1 downto 0);
        comp_op         : in     vl_logic_vector(3 downto 0);
        cust5_op        : in     vl_logic_vector(4 downto 0);
        cust5_limm      : in     vl_logic_vector(6 downto 0);
        result          : out    vl_logic_vector;
        flagforw        : out    vl_logic;
        flag_we         : out    vl_logic;
        cyforw          : out    vl_logic;
        cy_we           : out    vl_logic;
        carry           : in     vl_logic;
        thread_in       : in     vl_logic_vector(2 downto 0);
        thread_out      : out    vl_logic_vector(2 downto 0)
    );
end or1200_alu;
