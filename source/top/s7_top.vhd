library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

    use work.system_clocks_pkg.all;
    use work.system_control_pkg.system_control_FPGA_output_group;
    use work.led_driver_pkg.rgb_led;

entity top is
    port(
	    xclk : in std_logic;
        pi_uart_rx_serial : in std_logic;
        po_uart_tx_serial : out std_logic;

        ada_data  : in std_logic;
        ada_clock : out std_logic;
        ada_cs    : out std_logic;
        ada_mux   : out std_logic_vector(2 downto 0);

        adb_data  : in std_logic;
        adb_clock : out std_logic;
        adb_cs    : out std_logic;
        adb_mux   : out std_logic_vector(2 downto 0);

        bypass_relay : out std_logic;

        -- dhb io
        primary   : out work.phase_modulator_pkg.half_bridge;
        secondary : out work.phase_modulator_pkg.half_bridge;

        dhb_ad_data  : in std_logic;
        dhb_ad_clock : out std_logic;
        dhb_ad_cs    : out std_logic;

        -- llc io
        llc_gates    : out work.llc_modulator_pkg.hb_llc_pwm;

        llc_ad_data  : in std_logic;
        llc_ad_clock : out std_logic;
        llc_ad_cs    : out std_logic;

        -- pfc io
        ac1_switch : out std_logic;
        ac2_switch : out std_logic;

        po3_led1 : out rgb_led;
        po3_led2 : out rgb_led;
        po3_led3 : out rgb_led

    );
end top;

architecture behavioral of top is

    signal system_clocks : system_clock_group;
    signal system_control_FPGA_out : system_control_FPGA_output_group;

begin

    ada_clock <= system_control_FPGA_out.component_interconnect_FPGA_out.measurement_interface_FPGA_out.onboard_ad_control_FPGA_out.ada_clock;
    ada_cs    <= system_control_FPGA_out.component_interconnect_FPGA_out.measurement_interface_FPGA_out.onboard_ad_control_FPGA_out.ada_cs;
    ada_mux   <= system_control_FPGA_out.component_interconnect_FPGA_out.measurement_interface_FPGA_out.onboard_ad_control_FPGA_out.ada_mux;

    adb_clock <= system_control_FPGA_out.component_interconnect_FPGA_out.measurement_interface_FPGA_out.onboard_ad_control_FPGA_out.adb_clock;
    adb_cs    <= system_control_FPGA_out.component_interconnect_FPGA_out.measurement_interface_FPGA_out.onboard_ad_control_FPGA_out.adb_cs;
    adb_mux   <= system_control_FPGA_out.component_interconnect_FPGA_out.measurement_interface_FPGA_out.onboard_ad_control_FPGA_out.adb_mux;

    bypass_relay <= system_control_FPGA_out.bypass_relay;

    dhb_ad_clock <= system_control_FPGA_out.component_interconnect_FPGA_out.measurement_interface_FPGA_out.dhb_ad_clock;
    dhb_ad_cs    <= system_control_FPGA_out.component_interconnect_FPGA_out.measurement_interface_FPGA_out.dhb_ad_cs;

    llc_ad_clock <= system_control_FPGA_out.component_interconnect_FPGA_out.measurement_interface_FPGA_out.llc_ad_clock;
    llc_ad_cs    <= system_control_FPGA_out.component_interconnect_FPGA_out.measurement_interface_FPGA_out.llc_ad_cs;

    po3_led1 <= system_control_FPGA_out.component_interconnect_FPGA_out.po3_led1;
    po3_led2 <= system_control_FPGA_out.component_interconnect_FPGA_out.po3_led2;
    po3_led3 <= system_control_FPGA_out.component_interconnect_FPGA_out.po3_led3;

    po3_led3 <= system_control_FPGA_out.component_interconnect_FPGA_out.po3_led3;

    po_uart_tx_serial <= system_control_FPGA_out.component_interconnect_FPGA_out.po_uart_tx_serial;

    primary   <= system_control_FPGA_out.component_interconnect_FPGA_out.power_supply_control_FPGA_out.dhb_control_FPGA_out.phase_modulator_FPGA_out.primary;
    secondary <= system_control_FPGA_out.component_interconnect_FPGA_out.power_supply_control_FPGA_out.dhb_control_FPGA_out.phase_modulator_FPGA_out.secondary;

    llc_gates <= system_control_FPGA_out.component_interconnect_FPGA_out.power_supply_control_FPGA_out.llc_control_FPGA_out.llc_modulator_FPGA_out.llc_gates;

    ac1_switch <= system_control_FPGA_out.component_interconnect_FPGA_out.power_supply_control_FPGA_out.pfc_control_FPGA_out.pfc_modulator_FPGA_out.ac1_switch;
    ac2_switch <= system_control_FPGA_out.component_interconnect_FPGA_out.power_supply_control_FPGA_out.pfc_control_FPGA_out.pfc_modulator_FPGA_out.ac2_switch;

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
