library verilog;
use verilog.vl_types.all;
entity tb_or1200_ic_ram is
    generic(
        dw              : integer := 64;
        aw              : integer := 10
    );
end tb_or1200_ic_ram;
