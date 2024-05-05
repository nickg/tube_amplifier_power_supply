library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

    use work.system_clocks_pkg.all;

entity top is
    port(
	    xclk : in std_logic;
        pi_uart_rx_serial : in std_logic;
        po_uart_tx_serial : out std_logic;

        -- onboard adc io
        ada_data  : in std_logic;
        ada_clock : out std_logic;
        ada_cs    : out std_logic;
        ada_mux   : out std_logic_vector(2 downto 0);

        adb_data  : in std_logic;
        adb_clock : out std_logic;
        adb_cs    : out std_logic;
        adb_mux   : out std_logic_vector(2 downto 0);


        -- dhb io
        dhb_primary_high : out std_logic;
        dhb_primary_low  : out std_logic;
        dhb_secondary_high : out std_logic;
        dhb_secondary_low  : out std_logic;

        dhb_ad_data  : in std_logic;
        dhb_ad_clock : out std_logic;
        dhb_ad_cs    : out std_logic;

        -- llc io
        pri_high : out std_logic;
        pri_low  : out std_logic;
        sync1    : out std_logic;
        sync2    : out std_logic;

        llc_ad_data  : in std_logic;
        llc_ad_clock : out std_logic;
        llc_ad_cs    : out std_logic;

        -- pfc io
        ac1_switch : out std_logic;
        ac2_switch : out std_logic;

        -- misc
        bypass_relay : out std_logic;

        rgb_led1 : out std_logic_vector(2 downto 0);
        rgb_led2 : out std_logic_vector(2 downto 0);
        rgb_led3 : out std_logic_vector(2 downto 0)

    );
end top;

architecture behavioral of top is

    signal system_clocks : system_clock_group;

begin

------------------------------------------------------------------------
    clocks : entity work.pll_wrapper
	port map (
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
            system_clocks ,
            system_control_FPGA_in.component_interconnect_FPGA_in.measurement_interface_FPGA_in.onboard_ad_control_FPGA_in.ada_data => ada_data    ,
            system_control_FPGA_in.component_interconnect_FPGA_in.measurement_interface_FPGA_in.onboard_ad_control_FPGA_in.adb_data => adb_data    ,
            system_control_FPGA_in.component_interconnect_FPGA_in.measurement_interface_FPGA_in.dhb_ad_data                         => dhb_ad_data ,
            system_control_FPGA_in.component_interconnect_FPGA_in.measurement_interface_FPGA_in.llc_ad_data                         => llc_ad_data ,

            system_control_FPGA_in.component_interconnect_FPGA_in.pi_uart_rx_serial   => pi_uart_rx_serial ,
            system_control_FPGA_out.component_interconnect_FPGA_out.po_uart_tx_serial => po_uart_tx_serial ,

            system_control_FPGA_out.component_interconnect_FPGA_out.measurement_interface_FPGA_out.onboard_ad_control_FPGA_out.ada_clock => ada_clock ,
            system_control_FPGA_out.component_interconnect_FPGA_out.measurement_interface_FPGA_out.onboard_ad_control_FPGA_out.ada_cs    => ada_cs    ,
            system_control_FPGA_out.component_interconnect_FPGA_out.measurement_interface_FPGA_out.onboard_ad_control_FPGA_out.ada_mux   => ada_mux   ,

            system_control_FPGA_out.component_interconnect_FPGA_out.measurement_interface_FPGA_out.onboard_ad_control_FPGA_out.adb_clock => adb_clock ,
            system_control_FPGA_out.component_interconnect_FPGA_out.measurement_interface_FPGA_out.onboard_ad_control_FPGA_out.adb_cs    => adb_cs    ,
            system_control_FPGA_out.component_interconnect_FPGA_out.measurement_interface_FPGA_out.onboard_ad_control_FPGA_out.adb_mux   => adb_mux   ,

            system_control_FPGA_out.component_interconnect_FPGA_out.power_supply_control_FPGA_out.dhb_control_FPGA_out.phase_modulator_FPGA_out.primary.high_gate => dhb_primary_high     ,
            system_control_FPGA_out.component_interconnect_FPGA_out.power_supply_control_FPGA_out.dhb_control_FPGA_out.phase_modulator_FPGA_out.primary.low_gate  => dhb_primary_low      ,
            system_control_FPGA_out.component_interconnect_FPGA_out.power_supply_control_FPGA_out.dhb_control_FPGA_out.phase_modulator_FPGA_out.secondary.high_gate => dhb_secondary_high ,
            system_control_FPGA_out.component_interconnect_FPGA_out.power_supply_control_FPGA_out.dhb_control_FPGA_out.phase_modulator_FPGA_out.secondary.low_gate  => dhb_secondary_low  ,

            system_control_FPGA_out.component_interconnect_FPGA_out.measurement_interface_FPGA_out.dhb_ad_clock => dhb_ad_clock ,
            system_control_FPGA_out.component_interconnect_FPGA_out.measurement_interface_FPGA_out.dhb_ad_cs    => dhb_ad_cs    ,

            system_control_FPGA_out.component_interconnect_FPGA_out.power_supply_control_FPGA_out.llc_control_FPGA_out.llc_modulator_FPGA_out.llc_gates.pri_high => pri_high,
            system_control_FPGA_out.component_interconnect_FPGA_out.power_supply_control_FPGA_out.llc_control_FPGA_out.llc_modulator_FPGA_out.llc_gates.pri_low  => pri_low ,
            system_control_FPGA_out.component_interconnect_FPGA_out.power_supply_control_FPGA_out.llc_control_FPGA_out.llc_modulator_FPGA_out.llc_gates.sync1    => sync1   ,
            system_control_FPGA_out.component_interconnect_FPGA_out.power_supply_control_FPGA_out.llc_control_FPGA_out.llc_modulator_FPGA_out.llc_gates.sync2    => sync2   ,

            system_control_FPGA_out.component_interconnect_FPGA_out.measurement_interface_FPGA_out.llc_ad_clock => llc_ad_clock ,
            system_control_FPGA_out.component_interconnect_FPGA_out.measurement_interface_FPGA_out.llc_ad_cs    => llc_ad_cs    ,

            system_control_FPGA_out.component_interconnect_FPGA_out.power_supply_control_FPGA_out.pfc_control_FPGA_out.pfc_modulator_FPGA_out.ac1_switch  => ac1_switch ,
            system_control_FPGA_out.component_interconnect_FPGA_out.power_supply_control_FPGA_out.pfc_control_FPGA_out.pfc_modulator_FPGA_out.ac2_switch  => ac2_switch ,

            system_control_FPGA_out.bypass_relay => bypass_relay ,

            system_control_FPGA_out.component_interconnect_FPGA_out.po3_led1.red   => rgb_led1(2) ,
            system_control_FPGA_out.component_interconnect_FPGA_out.po3_led1.green => rgb_led1(1) ,
            system_control_FPGA_out.component_interconnect_FPGA_out.po3_led1.blue  => rgb_led1(0) ,

            system_control_FPGA_out.component_interconnect_FPGA_out.po3_led2.red   => rgb_led2(2) ,
            system_control_FPGA_out.component_interconnect_FPGA_out.po3_led2.green => rgb_led2(1) ,
            system_control_FPGA_out.component_interconnect_FPGA_out.po3_led2.blue  => rgb_led2(0) ,

            system_control_FPGA_out.component_interconnect_FPGA_out.po3_led3.red   => rgb_led3(2) ,
            system_control_FPGA_out.component_interconnect_FPGA_out.po3_led3.green => rgb_led3(1) ,
            system_control_FPGA_out.component_interconnect_FPGA_out.po3_led3.blue  => rgb_led3(0)
        );
------------------------------------------------------------------------
end behavioral;
