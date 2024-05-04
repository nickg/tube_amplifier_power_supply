library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

    use work.component_interconnect_pkg.all;
    use work.led_driver_pkg.all;
    use work.multiplier_pkg.all;
    use work.power_supply_control_pkg.all;
    use work.sincos_pkg.all;
    use work.cl10_fifo_control_pkg.all;
    use work.ram_control_pkg.all;

    use work.fpga_interconnect_pkg.all;
    
library onboard_adc_library;
    use onboard_adc_library.onboard_ad_control_pkg.get_ad_measurement;
    use onboard_adc_library.onboard_ad_control_pkg.ad_channel_is_ready;
    use onboard_adc_library.measurement_interface_pkg.all;
    use onboard_adc_library.psu_measurement_interface_pkg.all;

library common_library;
    use common_library.timing_pkg.all;
    use common_library.typedefines_pkg.all;

entity component_interconnect is
    port (
        system_clocks : in work.system_clocks_pkg.system_clock_group;    

        component_interconnect_FPGA_in : in component_interconnect_FPGA_input_group;
        component_interconnect_FPGA_out : out component_interconnect_FPGA_output_group;

        component_interconnect_data_in : in component_interconnect_data_input_group;
        component_interconnect_data_out : out component_interconnect_data_output_group
    );
end entity component_interconnect;

architecture rtl of component_interconnect is
    alias core_clock is system_clocks.core_clock;
    alias reset_n is system_clocks.pll_lock;

------------------------------------------------------------------------
    signal measurement_interface_clocks   : measurement_interface_clock_group;
    signal measurement_interface_data_in  : measurement_interface_data_input_group;
    signal measurement_interface_data_out : measurement_interface_data_output_group;
------------------------------------------------------------------------
    signal power_supply_control_clocks   : power_supply_control_clock_group;
    signal power_supply_control_data_in  : power_supply_control_data_input_group;
    signal power_supply_control_data_out :  power_supply_control_data_output_group;
------------------------------------------------------------------------
    signal bus_to_communications   : fpga_interconnect_record;
    signal bus_from_communications : fpga_interconnect_record;
------------------------------------------------------------------------
begin

    component_interconnect_data_out.measurement_interface_data_out <= measurement_interface_data_out;
------------------------------------------------------------------------
    measurement_interface_clocks <= (system_clocks.core_clock, system_clocks.core_clock, system_clocks.pll_lock);
    u_measurement_interface : measurement_interface 
    port map(
        measurement_interface_clocks,   
        component_interconnect_FPGA_in.measurement_interface_FPGA_in,  
        component_interconnect_FPGA_out.measurement_interface_FPGA_out, 
        measurement_interface_data_in,
        measurement_interface_data_out 
    );

------------------------------------------------------------------------
    burn_leds : led_driver
    port map(system_clocks.core_clock, 
            component_interconnect_FPGA_out.po3_led1, 
            component_interconnect_FPGA_out.po3_led2, 
            component_interconnect_FPGA_out.po3_led3, 
            component_interconnect_data_in.led1_color, 
            component_interconnect_data_in.led2_color, 
            component_interconnect_data_in.led3_color);

------------------------------------------------------------------------
        power_supply_control_clocks <= (core_clock      => system_clocks.core_clock,
                                        modulator_clock => system_clocks.modulator_clock,
                                        pll_lock        => system_clocks.pll_lock);

        measurement_interface_data_in                               <= power_supply_control_data_out.measurement_interface_data_in;
        power_supply_control_data_in.measurement_interface_data_out <= measurement_interface_data_out;
        power_supply_control_data_in.power_supplies_are_enabled     <= component_interconnect_data_in.power_supplies_are_enabled;

        u_power_supply_control : power_supply_control
        port map (
            power_supply_control_clocks,
            component_interconnect_FPGA_out.power_supply_control_FPGA_out,
            power_supply_control_data_in,
            power_supply_control_data_out
        );
------------------------------------------------------------------------
    u_communications : entity work.fpga_communications
        port map(
            clock                   => system_clocks.core_clock                           ,
            uart_rx                 => component_interconnect_FPGA_in.pi_uart_rx_serial   ,
            uart_tx                 => component_interconnect_FPGA_out.po_uart_tx_serial ,
            bus_to_communications   => bus_to_communications                              ,
            bus_from_communications => bus_from_communications
        );

------------------------------------------------------------------------
end rtl;
