
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

    use work.feedback_control_pkg.all;
    use work.multiplier_pkg.all;

    -- signal feedback_control_clocks   : feedback_control_clock_group;
    -- signal feedback_control_data_in  : feedback_measurements(0 to number_of_measurements -1);
    -- signal feedback_control_data_out : feedback_control_data_output_group;
    -- signal data_from_multiplier      : multiplier_data_output_group;
    -- signal data_to_multiplier        : multiplier_data_input_group;
    
    -- u_feedback_control : feedback_control
    -- port map( feedback_control_clocks,
    --	  feedback_control_data_in,
    --	  feedback_control_data_out,
    --    data_from_multiplier,
    --    data_to_multiplier);

architecture arch_pfc_voltage_control of feedback_control is

    alias dc_link is feedback_control_data_in(0).measurement;
    alias vac     is feedback_control_data_in(1).measurement;

    alias feedback_reference   is feedback_control_data_in(0).control_reference;
    alias control_is_requested is feedback_control_data_in(0).control_is_requested;
    alias multiplier_data_in   is data_to_multiplier;
    alias multiplier_data_out  is data_from_multiplier;

    signal mem : int18;
    signal ekp : int18;
    signal pi_out : int18;

    constant pi_saturate_high : int18 := 32768;
    constant pi_saturate_low : int18  := 0;

    constant kp : int18 := 3322*2;
    -- note, shift by 2 to the right when added to kp
    constant ki : int18 := 163;

begin


    pi_control_calculation : process(feedback_control_clocks.clock)
        variable process_counter : natural range 0 to 7;
        variable control_error : int18;

    begin
        if rising_edge(feedback_control_clocks.clock) then

            enable_multiplier(multiplier_data_in);
            feedback_control_data_out.feedback_is_ready <= false;

            if feedback_control_data_in(0).feedback_control_is_enabled = false then
                mem <= 0;
                feedback_control_data_out.control_out <= 0;
            end if;

            CASE process_counter is 
                WHEN 0 =>

                    control_error := feedback_control_data_in(0).control_reference - dc_link;
                    if control_error > 1000 then
                        control_error := 1000;
                    end if;

                    if control_is_requested and 
                        feedback_control_data_in(0).feedback_control_is_enabled then
                        increment(process_counter);
                    end if;

                WHEN 1 => 
                    alu_mpy(kp,control_error,multiplier_data_in);
                    increment(process_counter);

                WHEN 2 => 
                    increment(process_counter);
                    alu_mpy(ki,control_error,multiplier_data_in);

                WHEN 3 => 
                    -- pipeline mem calculation
                    increment(process_counter);

                WHEN 4 => 
                    pi_out <= get_result(multiplier_data_out,15) + mem/4;
                    ekp <= get_result(multiplier_data_out,15);
                    increment(process_counter);

                WHEN 5 => 
                    increment(process_counter);

                    mem <= mem + get_result(multiplier_data_out,15);
                    if pi_out >   pi_saturate_high then
                        pi_out <= pi_saturate_high;
                        mem <=    pi_saturate_high - ekp;
                    end if;

                    if pi_out <   pi_saturate_low then
                        pi_out <= pi_saturate_low ;
                        mem <=    pi_saturate_low - ekp;
                    end if;
                WHEN 6 => 
                    increment(process_counter);
                    alu_mpy(pi_out,vac,multiplier_data_in); 

                WHEN 7 => 
                    if multiplier_is_ready(multiplier_data_out) then
                        feedback_control_data_out.control_out <= get_result(multiplier_data_out,13);
                        feedback_control_data_out.feedback_is_ready <= true;
                        process_counter := 0;
                    end if;

                WHEN others =>
                    process_counter := 0;
            end CASE;
        end if; --rising_edge
    end process;	

end arch_pfc_voltage_control;

