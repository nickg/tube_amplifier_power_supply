library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

    use work.feedback_control_pkg.all;
    use work.multiplier_pkg.all;

-- entity feedback_control is
--     generic(number_of_measurements : natural);
--     port (
--         feedback_control_clocks : in feedback_control_clock_group; 
--         feedback_control_data_in : in feedback_measurements(0 to number_of_measurements -1 );
--         feedback_control_data_out : out feedback_control_data_output_group;
--         data_from_multiplier : in multiplier_data_output_group;
--         data_to_multiplier :  out multiplier_data_input_group
--     );
-- end entity;

architecture arch_llc_pi_control of feedback_control is
    alias feedback_measurement is feedback_control_data_in(0).measurement;
    alias feedback_reference is feedback_control_data_in(0).control_reference;
    alias control_is_requested is feedback_control_data_in(0).control_is_requested;
    alias multiplier_data_in is data_to_multiplier;
    alias multiplier_data_out is data_from_multiplier;

    signal mem : int18;
    signal ekp : int18;
    signal pi_out : int18;

    constant pi_saturate_high : int18 := 32768;
    constant pi_saturate_low : int18  := 0;

    constant kp : int18 := 7e3;
    constant ki : int18 := 200;

begin

    feedback_control_data_out.control_out <= pi_out;

    pi_control_calculation : process(feedback_control_clocks.clock)
        variable process_counter : natural range 0 to 7;
        variable control_error : int18;

        
    begin
        if rising_edge(feedback_control_clocks.clock) then

            enable_multiplier(multiplier_data_in);
            feedback_control_data_out.feedback_is_ready <= false;

            if feedback_control_data_in(0).feedback_control_is_enabled = false then
                mem <= 0;
            end if;

            
                CASE process_counter is
                    WHEN 0 =>
                        -- do nothing
                        control_error := feedback_reference - feedback_measurement;

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
                    pi_out <= get_result(multiplier_data_out,15) + mem;
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
                        pi_out <= pi_saturate_low;
                        mem <=    pi_saturate_low - ekp;
                    end if;

                    WHEN 6 =>
                        increment(process_counter);
                        alu_mpy(pi_out, 372, multiplier_data_in);

                    WHEN 7 =>
                        if multiplier_is_ready(multiplier_data_out) then
                            pi_out <= get_result(multiplier_data_out,15) + 474;
                            feedback_control_data_out.feedback_is_ready <= true;
                            process_counter := 0;
                        end if;


                    WHEN others =>
                        process_counter := 0;
                end CASE;
        end if; --rising_edge
    end process;	

end arch_llc_pi_control;

