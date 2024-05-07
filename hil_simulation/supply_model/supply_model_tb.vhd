LIBRARY ieee  ; 
    USE ieee.NUMERIC_STD.all  ; 
    USE ieee.std_logic_1164.all  ; 
    use std.textio.all;
    use ieee.math_real.all;

library vunit_lib;
context vunit_lib.vunit_context;

    use work.write_pkg.all;

entity supply_model_tb is
  generic (runner_cfg : string);
end;

architecture vunit_simulation of supply_model_tb is

    constant clock_period      : time    := 1 ns;
    signal simulator_clock     : std_logic := '0';
    signal simulation_counter  : natural   := 0;
    -----------------------------------
    -- simulation specific signals ----

    signal realtime : real := 0.0;
    signal timestep : real := 1.0e-6;

    signal sequencer : natural := 1;

    signal current : real := 0.0;
    signal voltage : real := 0.0;
    signal r       : real := 100.0e-3;
    signal l       : real := timestep/50.0e-6;
    signal c       : real := timestep/100.0e-6;
    signal uin     : real := 1.0;

    signal load : real := 0.0;

begin

------------------------------------------------------------------------
    simtime : process
    begin
        test_runner_setup(runner, runner_cfg);
        wait until realtime >= 15.0e-3;
        test_runner_cleanup(runner); -- Simulation ends here
        wait;
    end process simtime;	

    simulator_clock <= not simulator_clock after clock_period/2.0;
------------------------------------------------------------------------

    stimulus : process(simulator_clock)

        type realarray is array (natural range <>) of real;
        variable ik : realarray(1 to 4) := (others => 0.0);
        variable uk : realarray(1 to 4) := (others => 0.0);

        type lc_record is record
            current : real;
            voltage : real;
        end record;

    ------------------------------
        function calculate_lc
        (
            lc : lc_record;
            l_gain : real;
            c_gain : real;
            r_l : real;
            r_load : real;
            input_voltage : real;
            load_current : real
        )
        return lc_record
        is
            variable retval : lc_record;
        begin

            retval.current := ((input_voltage - lc.voltage) - r_l*lc.current + r_load * load_current) * l_gain;
            retval.voltage := (lc.current - load_current)*c_gain;

            return retval;
            
        end calculate_lc;
    ------------------------------
        type lc_array is array (integer range 1 to 4) of lc_record;
        variable k_lc : lc_array;

        file file_handler : text open write_mode is "supply_model_tb.dat";
    begin
        if rising_edge(simulator_clock) then
            simulation_counter <= simulation_counter + 1;
            if simulation_counter = 0 then
                init_simfile(file_handler, ("time", "volt", "curr", "load"));
            end if;

            case sequencer is
                when 0 =>
                    k_lc(1) := calculate_lc((current, voltage),l/2.0, c/2.0, r, 0.00, uin, load);
                    ik(1) := k_lc(1).current;
                    uk(1) := k_lc(1).voltage;

                    k_lc(2) := calculate_lc((current + k_lc(1).current, voltage + k_lc(1).voltage),l/2.0, c/2.0, r, 0.00, uin, load);

                    ik(2) := k_lc(2).current;
                    uk(2) := k_lc(2).voltage;

                    k_lc(3) := calculate_lc((current + k_lc(2).current, voltage + k_lc(2).voltage),l, c, r, 0.00, uin, load);
                    ik(3) := k_lc(3).current;
                    uk(3) := k_lc(3).voltage;

                    k_lc(4) := calculate_lc((current + k_lc(3).current, voltage + k_lc(3).voltage),l, c, r, 0.00, uin, load);
                    ik(4) := k_lc(4).current;
                    uk(4) := k_lc(4).voltage;

                    current <= current + 1.0/6.0 * (ik(1) * 2.0 + 4.0 * ik(2) + 2.0 * ik(3) + ik(4));
                    voltage <= voltage + 1.0/6.0 * (uk(1) * 2.0 + 4.0 * uk(2) + 2.0 * uk(3) + uk(4));

                when 1 => 
                    realtime <= realtime + timestep;
                    write_to(file_handler,(realtime, voltage, current, load));

                when others => --do nothing
            end case;

            if realtime > 5.0e-3 then
                load <= 1.0;
            end if;

            if realtime > 10.0e-3 then
                uin <= 2.0;
            end if;

            sequencer <= sequencer + 1;
            if sequencer > 0 then
                sequencer <= 0;
            end if;

        end if; -- rising_edge
    end process stimulus;	
------------------------------------------------------------------------
end vunit_simulation;
