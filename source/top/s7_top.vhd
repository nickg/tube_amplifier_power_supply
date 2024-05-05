library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

    use work.system_clocks_pkg.all;
    use work.system_control_pkg.system_control_FPGA_output_group;

entity top is
    port(
	    xclk : in std_logic;
        dhb_ad_data       : in std_logic;
        llc_ad_data       : in std_logic;
        ada_data          : in std_logic;
        adb_data          : in std_logic;
        pi_uart_rx_serial : in std_logic;
        system_control_FPGA_out : out system_control_FPGA_output_group
    );
end top;

architecture behavioral of top is

    signal system_clocks : system_clock_group;


begin
------------------------------------------------------------------------
    clocks : entity work.pll_wrapper
	port map
	(
		xclk           => xclk,
        core_clk       => system_clocks.core_clock,
        modulator_clk  => system_clocks.modulator_clock,
        modulator_clk2 => system_clocks.adc_clock,
        pll_lock       => system_clocks.pll_lock
	);
	system_clocks.adc_pll_lock <= system_clocks.pll_lock;
------------------------------------------------------------------------
    u_system_control : entity work.system_control
        port map(
            system_clocks,
            system_control_FPGA_in.component_interconnect_FPGA_in.measurement_interface_FPGA_in.dhb_ad_data => dhb_ad_data,
            system_control_FPGA_in.component_interconnect_FPGA_in.measurement_interface_FPGA_in.llc_ad_data => llc_ad_data,
            system_control_FPGA_in.component_interconnect_FPGA_in.measurement_interface_FPGA_in.onboard_ad_control_FPGA_in.ada_data => ada_data,
            system_control_FPGA_in.component_interconnect_FPGA_in.measurement_interface_FPGA_in.onboard_ad_control_FPGA_in.adb_data => adb_data,
            system_control_FPGA_in.component_interconnect_FPGA_in.pi_uart_rx_serial => pi_uart_rx_serial,

            system_control_FPGA_out => system_control_FPGA_out
        );
------------------------------------------------------------------------
end behavioral;
