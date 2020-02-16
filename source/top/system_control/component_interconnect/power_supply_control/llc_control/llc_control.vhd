library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

library onboard_adc_library;
    use onboard_adc_library.measurement_interface_pkg.all;
    use onboard_adc_library.psu_measurement_interface_pkg.all;

library work;
    use work.llc_control_pkg.all;
    use work.llc_modulator_pkg.all;
    use work.multiplier_pkg.all;

entity llc_control is
    port (
        llc_control_clocks : in llc_control_clock_group;
        llc_control_FPGA_out : out llc_control_FPGA_output_group;
        llc_control_data_in : in llc_control_data_input_group;
        llc_control_data_out : out llc_control_data_output_group
    );
end llc_control;

architecture rtl of llc_control is

    alias core_clock is llc_control_clocks.core_clock;
    alias modulator_clock is llc_control_clocks.modulator_clock;
    alias adc_interface is llc_control_data_in.measurement_interface_data_out;
------------------------------------------------------------------------
    signal multiplier_clocks   : multiplier_clock_group;
    signal multiplier_data_in  : multiplier_data_input_group;
    signal multiplier_data_out :  multiplier_data_output_group;
------------------------------------------------------------------------
    signal llc_modulator_clocks   : llc_modulator_clock_group;
    signal llc_modulator_data_in  : llc_modulator_data_input_group;
    signal llc_modulator_data_out : llc_modulator_data_output_group;
------------------------------------------------------------------------
    signal llc_voltage : int18;
    function std_to_bool
    (
        check_for_1 : std_logic
    )
    return boolean
    is
    begin
        if check_for_1 = '1' then
            return true;
        else 
            return false;
        end if;
        
    end std_to_bool;
begin
    heater_control : process(core_clock)
        type t_heater_control_states is (idle, precharge, rampup, tripped);
        variable st_heater_control_states : t_heater_control_states;
        
    begin
        if rising_edge(core_clock) then
            -- get llc voltage measurement from measurement bus
            get_llc_voltage(adc_interface, llc_voltage);

            CASE st_heater_control_states is
                WHEN idle =>
                    disable_llc_modulator(llc_modulator_data_in);

                WHEN precharge =>
                -- wait for precharge ready
                    enable_llc_modulator(llc_modulator_data_in);

                WHEN rampup =>
                    -- 1. measure voltage with maximum switching frequency
                    -- 2. set reference to match measurement
                    -- 3. add 1 to measurement until reference matches set value
                    enable_llc_modulator(llc_modulator_data_in);

                WHEN tripped =>
                    disable_llc_modulator(llc_modulator_data_in);

                WHEN others =>
                    disable_llc_modulator(llc_modulator_data_in);
            end CASE;
        end if; --rising_edge
    end process heater_control;	
------------------------------------------------------------------------
    multiplier_clocks.dsp_clock <= core_clock;
    u_multiplier : multiplier
        port map(
            multiplier_clocks, 
            multiplier_data_in,
            multiplier_data_out 
        );
------------------------------------------------------------------------
    --TODO, create control logic for safe llc start
    llc_modulator_clocks <= (core_clock => core_clock, modulator_clock => modulator_clock);
    -- llc_modulator_data_in.llc_is_enabled <= std_to_bool(llc_control_clocks.pll_lock);
    u_llc_modulator : llc_modulator
    port map
    (
        llc_modulator_clocks,
        llc_control_FPGA_out.llc_modulator_FPGA_out,
        llc_modulator_data_in, 
        llc_modulator_data_out
    );
------------------------------------------------------------------------
end rtl;
