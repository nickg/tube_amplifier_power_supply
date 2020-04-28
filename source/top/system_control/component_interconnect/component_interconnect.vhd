library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

library work;
    use work.component_interconnect_pkg.all;
    use work.led_driver_pkg.all;
    use work.uart_pkg.all;
    use work.multiplier_pkg.all;
    use work.power_supply_control_pkg.all;
    use work.sincos_pkg.all;
    
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

------------------------------------------------------------------------
    signal si_uart_start_event : std_logic;
    signal si16_uart_tx_data   : std_logic_vector(15 downto 0);
    signal so_uart_ready_event :  std_logic;
    signal so16_uart_rx_data   :  std_logic_vector(15 downto 0);
------------------------------------------------------------------------
    signal measurement_interface_clocks   : measurement_interface_clock_group;
    signal measurement_interface_data_in  : measurement_interface_data_input_group;
    signal measurement_interface_data_out : measurement_interface_data_output_group;
------------------------------------------------------------------------
    signal multiplier_clocks   : multiplier_clock_group;
    signal multiplier_data_in  : multiplier_data_input_group;
    signal multiplier_data_out :  multiplier_data_output_group;
------------------------------------------------------------------------
    signal power_supply_control_clocks   : power_supply_control_clock_group;
    signal power_supply_control_data_in  : power_supply_control_data_input_group;
    signal power_supply_control_data_out :  power_supply_control_data_output_group;
------------------------------------------------------------------------
    signal sincos_clocks   : sincos_clock_group;
    signal sincos_data_in  : sincos_data_input_group;
    signal sincos_data_out : sincos_data_output_group;
------------------------------------------------------------------------
    signal angle : int18;
------------------------------------------------------------------------
    signal delay_timer_data_in  : delay_timer_data_input_group;
    signal delay_timer_data_out : delay_timer_data_output_group;
------------------------------------------------------------------------     
    signal measurement_container : uint16_array(0 to 12);
    signal index : uint8;
    signal ada_meas_buffer : uint16;
    signal adb_meas_buffer : uint16;
    signal send_index : uint8;

    procedure send_data_to_uart
    (
        uart_is_requested : boolean;
        signal start_uart : out std_logic;
        signal uart_tx_data : out std_logic_vector(15 downto 0);
        data_array : uint16_array;
        signal tx_index : inout integer
    ) is
        variable data_to_stream : integer;
    begin
        data_to_stream := data_array(tx_index);

        if uart_is_requested then
            start_uart <= '1';
            uart_tx_data <= std_logic_vector(to_unsigned(data_to_stream,16));

            tx_index <= tx_index + 1;
            if tx_index > 11 then
                tx_index <= 0;
            end if;

        else
            start_uart <= '0';
        end if;
        
    end send_data_to_uart;

begin
------------------------------------------------------------------------
    u_1us_timer : delay_timer
    generic map (count_up_to => 1280)
    port map( core_clock,
              delay_timer_data_in,
              delay_timer_data_out);

    test_uart : process(core_clock)
        type t_uart_data_log_states is (idle, stream_data);
        variable st_uart_data_log_states : t_uart_data_log_states;

    begin
        if rising_edge(core_clock) then
            if system_clocks.pll_lock = '0' then
            -- reset state
                st_uart_data_log_states := idle;
    
            else

                si_uart_start_event <= '0';

                get_ada_measurement(measurement_interface_data_out,ada_meas_buffer);
                get_adb_measurement(measurement_interface_data_out,adb_meas_buffer);
                if ada_is_ready(measurement_interface_data_out) then
                    measurement_container(index) <= ada_meas_buffer;
                    index <= index + 1;
                    if index > 11 then
                        index <= 0;
                    end if;
                end if;

                CASE st_uart_data_log_states is
                    WHEN idle =>

                        st_uart_data_log_states := idle;

                        request_delay(delay_timer_data_in,delay_timer_data_out,800e2);

                        if timer_is_ready(delay_timer_data_out) then
                            st_uart_data_log_states := stream_data;
                        end if;
                    WHEN stream_data =>
                        request_delay(delay_timer_data_in,delay_timer_data_out,1);

                        send_data_to_uart(timer_is_ready(delay_timer_data_out), 
                                            si_uart_start_event, 
                                            si16_uart_tx_data, 
                                            measurement_container,
                                            send_index);

                        if timer_is_ready(delay_timer_data_out) and send_index > 11 then
                            st_uart_data_log_states := idle;
                        end if;

                        -- si_uart_start_event
                    WHEN others => 
                        -- do nothing
                end CASE;
    
            end if; -- rstn
        end if; --rising_edge
    end process test_uart;	

------------------------------------------------------------------------  
-- measurement_interface_data_in <= component_interconnect_data_in.measurement_interface_data_in;
    component_interconnect_data_out.measurement_interface_data_out <= measurement_interface_data_out;
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
    port map(system_clocks.core_clock, component_interconnect_FPGA_out.po3_led1, component_interconnect_FPGA_out.po3_led2, component_interconnect_FPGA_out.po3_led3, component_interconnect_data_in.led1_color, component_interconnect_data_in.led2_color, component_interconnect_data_in.led3_color);
------------------------------------------------------------------------
    u_uart_event_ctrl : uart_event_ctrl
	generic map(25,2,2)
    port map(
	    system_clocks.core_clock,
	    component_interconnect_FPGA_out.po_uart_tx_serial,
	    component_interconnect_FPGA_in.pi_uart_rx_serial,
	    si_uart_start_event,
	    si16_uart_tx_data,
	    so_uart_ready_event,
	    so16_uart_rx_data);
------------------------------------------------------------------------
    multiplier_clocks.dsp_clock <= system_clocks.core_clock;
    u_multiplier : multiplier
        port map(
            multiplier_clocks, 
            multiplier_data_in,
            multiplier_data_out);
------------------------------------------------------------------------
        power_supply_control_clocks <= (core_clock      => system_clocks.core_clock,
                                        modulator_clock => system_clocks.modulator_clock,
                                        pll_lock        => system_clocks.pll_lock);

        measurement_interface_data_in <= power_supply_control_data_out.measurement_interface_data_in;
        power_supply_control_data_in.measurement_interface_data_out <= measurement_interface_data_out;
        u_power_supply_control : power_supply_control
        port map (
            power_supply_control_clocks,
            component_interconnect_FPGA_out.power_supply_control_FPGA_out,
            power_supply_control_data_in,
            power_supply_control_data_out
        );
------------------------------------------------------------------------
    sincos_clocks <= (alu_clock => system_clocks.core_clock, reset_n => system_clocks.pll_lock);
    -- sine          <= sincos_data_out.sine;
    -- cosine        <= sincos_data_out.cosine;

    sincos_data_in.angle_pirad <= angle;
    -- sincos_data_in <= (angle_pirad => angle, 
    --                   sincos_is_requested => sincos_is_requested, 
    --                   multiplier_data_out => multiplier_data_out);
    --
    u_sincos : sincos
    port map
    (
        sincos_clocks,   
        sincos_data_in, 
        sincos_data_out 
    );
end rtl;
