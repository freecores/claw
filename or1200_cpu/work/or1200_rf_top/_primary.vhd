library verilog;
use verilog.vl_types.all;
entity or1200_rf_top is
    generic(
        dw              : integer := 32;
        aw              : integer := 5
    );
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        supv            : in     vl_logic;
        wb_freeze       : in     vl_logic;
        addrw           : in     vl_logic_vector;
        dataw           : in     vl_logic_vector;
        addrw2          : in     vl_logic_vector;
        dataw2          : in     vl_logic_vector;
        we              : in     vl_logic;
        we2             : in     vl_logic;
        flushpipe       : in     vl_logic;
        id_freeze       : in     vl_logic;
        addra           : in     vl_logic_vector;
        addrb           : in     vl_logic_vector;
        dataa           : out    vl_logic_vector;
        datab           : out    vl_logic_vector;
        rda             : in     vl_logic;
        rdb             : in     vl_logic;
        addra2          : in     vl_logic_vector;
        addrb2          : in     vl_logic_vector;
        dataa2          : out    vl_logic_vector;
        datab2          : out    vl_logic_vector;
        rda2            : in     vl_logic;
        rdb2            : in     vl_logic;
        spr_cs          : in     vl_logic;
        spr_write       : in     vl_logic;
        spr_addr        : in     vl_logic_vector(31 downto 0);
        spr_dat_i       : in     vl_logic_vector(31 downto 0);
        spr_dat_o       : out    vl_logic_vector(31 downto 0);
        current_thread_read: in     vl_logic_vector(2 downto 0);
        current_thread_read_out: out    vl_logic_vector(2 downto 0);
        current_thread_write: in     vl_logic_vector(2 downto 0)
    );
end or1200_rf_top;
