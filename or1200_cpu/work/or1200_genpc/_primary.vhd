library verilog;
use verilog.vl_types.all;
entity or1200_genpc is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        icpu_adr_o      : out    vl_logic_vector(31 downto 0);
        icpu_cycstb_o   : out    vl_logic;
        icpu_sel_o      : out    vl_logic_vector(3 downto 0);
        icpu_tag_o      : out    vl_logic_vector(3 downto 0);
        icpu_rty_i      : in     vl_logic;
        icpu_adr_i      : in     vl_logic_vector(31 downto 0);
        branch_op       : in     vl_logic_vector(2 downto 0);
        except_type     : in     vl_logic_vector(3 downto 0);
        except_prefix   : in     vl_logic;
        branch_addrofs  : in     vl_logic_vector(31 downto 2);
        lr_restor       : in     vl_logic_vector(31 downto 0);
        flag            : in     vl_logic;
        taken           : out    vl_logic;
        except_start    : in     vl_logic;
        binsn_addr      : in     vl_logic_vector(31 downto 2);
        epcr            : in     vl_logic_vector(31 downto 0);
        spr_dat_i       : in     vl_logic_vector(31 downto 0);
        spr_pc_we       : in     vl_logic;
        genpc_refetch   : in     vl_logic;
        genpc_freeze    : in     vl_logic;
        genpc_stop_prefetch: in     vl_logic;
        no_more_dslot   : in     vl_logic;
        thread_out      : out    vl_logic_vector(2 downto 0);
        branch_thread   : in     vl_logic_vector(2 downto 0);
        wb_thread       : in     vl_logic_vector(2 downto 0);
        except_thread   : in     vl_logic_vector(2 downto 0)
    );
end or1200_genpc;
