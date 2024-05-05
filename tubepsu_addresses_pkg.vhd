library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

package tubepsu_addresses_pkg is

    constant system_control_test_address : natural := 101;
    constant system_control_dc_link_address : natural := 102;

    constant interconnect_test_address : natural := 100;

end package tubepsu_addresses_pkg;
