library verilog;
use verilog.vl_types.all;
entity or1200_operandmuxes is
    generic(
        width           : integer := 32
    );
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        id_freeze       : in     vl_logic;
        ex_freeze       : in     vl_logic;
        rf_dataa        : in     vl_logic_vector;
        rf_datab        : in     vl_logic_vector;
        ex_forw         : in     vl_logic_vector;
        wb_forw         : in     vl_logic_vector;
        rf_dataa2       : in     vl_logic_vector;
        rf_datab2       : in     vl_logic_vector;
        ex_forw2        : in     vl_logic_vector;
        wb_forw2        : in     vl_logic_vector;
        simm            : in     vl_logic_vector;
        sel_a           : in     vl_logic_vector(1 downto 0);
        sel_b           : in     vl_logic_vector(1 downto 0);
        operand_a       : out    vl_logic_vector;
        operand_b       : out    vl_logic_vector;
        muxed_b         : out    vl_logic_vector;
        simm2           : in     vl_logic_vector;
        sel_a2          : in     vl_logic_vector(1 downto 0);
        sel_b2          : in     vl_logic_vector(1 downto 0);
        operand_a2      : out    vl_logic_vector;
        operand_b2      : out    vl_logic_vector;
        muxed_b2        : out    vl_logic_vector;
        thread_in       : in     vl_logic_vector(2 downto 0);
        thread_out      : out    vl_logic_vector(2 downto 0)
    );
end or1200_operandmuxes;
