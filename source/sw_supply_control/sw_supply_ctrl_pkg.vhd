library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

library dhb_lib;
	use dhb_lib.dhb_pkg.all;
package sw_suppy_ctrl_pkg is

    component sw_supply_ctrl is
    port(
	    core_clk : in std_logic;
	    modulator_clk : in std_logic;
	    modulator_clk2 : in std_logic;
-- aux pwm
	    po_aux_pwm : out std_logic;
-- PFC pwm
	    po2_pfc_pwm : out std_logic_vector(1 downto 0);
-- heater pwm
	    po2_ht_pri_pwm : out std_logic_vector(1 downto 0);
	    po2_ht_sec_pwm : out std_logic_vector(1 downto 0);
-- DBH pwm
	    po2_DHB_pri_pwm : out std_logic_vector(1 downto 0);
	    po2_DHB_sec_pwm : out std_logic_vector(1 downto 0);
-- onboard ad data in
	    si_std17_ada_bus : in std_logic_vector(16 downto 0);
	    si_std17_adb_bus : in std_logic_vector(16 downto 0);
-- ext ad converter data, in ad bus clock domain
	    si16_ext_ad1_data : in std_logic_vector(15 downto 0);
	    si16_ext_ad2_data : in std_logic_vector(15 downto 0);
-- ad trigger signals
	    to_ada_triggers : out t_ad_triggers;
	    to_adb_triggers : out t_ad_triggers;
-- ext ad trigger signals, clocked in modulator_clk2 domain    
	    so_ext_ad1_start : out std_logic;
	    so_ext_ad2_start : out std_logic;
-- test data out 
	    so_std18_test_data : out std_logic_vector(17 downto 0);
-- uart rx for testing 
	    si_uart_ready_event	: in std_logic;
	    si16_uart_rx_data	: in std_logic_vector(15 downto 0);
-- system command signals from main state machine
	    si_tcmd_system_cmd : in tcmd_system_commands
	);
    end component;

end sw_suppy_ctrl_pkg;
