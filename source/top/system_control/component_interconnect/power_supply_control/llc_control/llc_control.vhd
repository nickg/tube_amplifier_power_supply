library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

library onboard_adc_library;
    use onboard_adc_library.measurement_interface_pkg.all;
    use onboard_adc_library.psu_measurement_interface_pkg.all;

library common_library;
    use common_library.timing_pkg.all;
    use common_library.typedefines_pkg.all;

    use work.llc_control_pkg.all;
    use work.llc_control_internal_pkg.all;
    use work.llc_modulator_pkg.all;
    use work.multiplier_pkg.all;
    use work.feedback_control_pkg.all;

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

----------------------- adc interface ----------------------------------
    alias adc_interface is llc_control_data_in.measurement_interface_data_out;
    signal llc_voltage : int18;
----------------------- multiplier signals -----------------------------
    signal multiplier_clocks   : multiplier_clock_group;
    signal multiplier_data_in  : multiplier_input_array(0 to 0);
    signal multiplier_data_out :  multiplier_output_array(0 to 0);
----------------------- modulator interface signals --------------------
    signal llc_modulator_clocks   : llc_modulator_clock_group;
    signal llc_modulator_data_in  : llc_modulator_data_input_group;
    signal llc_modulator_data_out : llc_modulator_data_output_group;
----------------------- delay interface signals ------------------------
    signal delay_timer_data_in  : delay_timer_data_input_group;
    signal delay_timer_data_out : delay_timer_data_output_group;
------------------------------------------------------------------------
    signal deadtime : uint12;
----------------------- feedback control signals -----------------------
    signal trigger_llc_control : boolean;

    for u_feedback_control : feedback_control use entity work.feedback_control(arch_llc_pi_control);

    constant number_of_measurements    : natural := 1;
    signal feedback_control_clocks     : feedback_control_clock_group;
    signal feedback_control_data_in    : feedback_measurements(0 to number_of_measurements -1);
    signal feedback_control_data_out   : feedback_control_data_output_group;
    signal data_from_multiplier        : multiplier_data_output_group;
    signal data_to_multiplier          : multiplier_data_input_group;
    signal feedback_control_is_enabled : boolean;

    constant heater_ref_4v9 : integer := 44912;
    constant heater_ref_5v1 : integer := 46745;
    constant heater_ref_5v3 : integer := 48578;
    constant heater_ref_5v7 : integer := 52244;
    constant heater_ref_6v0 : integer := 54933;
    constant heater_ref_6v3 : integer := 57744;
    constant heater_ref_6v5 : integer := 59577;

------------------------------------------------------------------------
begin

------------------ delay timer module ----------------------------------
    delay_1us : delay_timer
    generic map (count_up_to => 128)
    port map( core_clock,
    	  delay_timer_data_in,
    	  delay_timer_data_out);

------------------ multiplier module -----------------------------------
    multiplier_clocks.dsp_clock <= core_clock;
    
    llc_multipliers:
    for i in 0 to multiplier_data_out'right 
    generate
    u_multiplier : multiplier
        port map(
            multiplier_clocks, 
            multiplier_data_in(i),
            multiplier_data_out(i));
    end generate;

------------------ feedback control module -----------------------------

    feedback_control_clocks <= (clock => core_clock);

    feedback_control_data_in(0) <= (feedback_control_is_enabled => feedback_control_is_enabled,
                                   measurement                  => llc_voltage,
                                   control_is_requested         => trigger_llc_control,
                                   control_reference            => heater_ref_6v0);

    u_feedback_control : feedback_control
    generic map(number_of_measurements => 1)
    port map( feedback_control_clocks,
              feedback_control_data_in,
              feedback_control_data_out,
              multiplier_data_out(0),
              multiplier_data_in(0));

------------------------------------------------------------------------
    heater_control : process(core_clock)
        type t_heater_control_states is (idle, precharge, run, tripped);
        variable st_heater_control_states : t_heater_control_states;
        ------------------------------------------------------------------------
        variable process_counter : uint8;
        
    begin
        if rising_edge(core_clock) then
            if llc_control_clocks.pll_lock = '0' then
                disable_llc_modulator(llc_modulator_data_in);
                st_heater_control_states := idle;
                trigger_llc_control <= false;
                llc_control_data_out.llc_is_ready <= false;
            else

                get_llc_voltage(adc_interface, llc_voltage);
                trigger_llc_control <= llc_voltage_is_ready(adc_interface);

                feedback_control_is_enabled <= false;
                llc_control_data_out.llc_is_ready <= false;
                init_timer(delay_timer_data_in);
                CASE st_heater_control_states is
                    WHEN idle =>

                        deadtime <= 474-28;

                        disable_llc_modulator(llc_modulator_data_in);

                        st_heater_control_states := idle;
                        if llc_converter_is_enabled(llc_control_data_in) then
                            st_heater_control_states := precharge;
                        end if;

                    WHEN precharge =>

                        enable_llc_modulator(llc_modulator_data_in);
                        set_period(473,llc_modulator_data_in);

                        request_delay(delay_timer_data_in,delay_timer_data_out,50);

                        if timer_is_ready(delay_timer_data_out) then 
                            deadtime <= deadtime - 1;
                            set_deadtime(deadtime, llc_modulator_data_in);
                            trigger_modulator_changes(llc_modulator_data_in);
                        end if;


                        st_heater_control_states := precharge;
                        if deadtime = 64 then -- 250 ns deadtime
                            st_heater_control_states := run;
                        end if;

                    WHEN run =>
                        st_heater_control_states := run;
                        llc_control_data_out.llc_is_ready <= true;

                        feedback_control_is_enabled <= true;
                        if feedback_is_ready(feedback_control_data_out) then
                            set_period(get_control_output(feedback_control_data_out),llc_modulator_data_in);
                            trigger_modulator_changes(llc_modulator_data_in);
                        end if;

                    WHEN tripped =>
                        disable_llc_modulator(llc_modulator_data_in);
                        st_heater_control_states := idle;
                end CASE;
            end if;
        end if; --rising_edge
    end process heater_control;	
------------------------------------------------------------------------
    llc_modulator_clocks <= (core_clock => core_clock, modulator_clock => modulator_clock);
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
