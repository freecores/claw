library verilog;
use verilog.vl_types.all;
entity tb_or1200_cpu is
    generic(
        dw              : integer := 32;
        aw              : integer := 5
    );
end tb_or1200_cpu;
