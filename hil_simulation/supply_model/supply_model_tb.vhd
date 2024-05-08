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
    signal timestep : real := 0.25e-6;

    signal sequencer : natural := 1;

    type lc_record is record
        current : real;
        voltage : real;
    end record;

    signal lc1 : lc_record := ((others => 0.0));
    signal lc2 : lc_record := ((others => 0.0));
    signal lc3 : lc_record := ((others => 0.0));
    signal i3 : real := 0.0;

    signal dc_link : real := 1.5;
    signal duty    : real := 0.5;
    signal load_r  : real := 1.0;

    signal r        : real := 50.0e-3;
    signal l        : real := timestep/2.2e-6;
    signal c        : real := timestep/0.68e-6;
    signal uin      : real := 1.0;

    signal load : real := 0.0;

begin

------------------------------------------------------------------------
    simtime : process
    begin
        test_runner_setup(runner, runner_cfg);
        wait until realtime >= 65.0e-3;
        test_runner_cleanup(runner); -- Simulation ends here
        wait;
    end process simtime;	

    simulator_clock <= not simulator_clock after clock_period/2.0;
------------------------------------------------------------------------

    stimulus : process(simulator_clock)

    ------------------------------
        type lc_array is array (integer range 1 to 4) of lc_record;
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
        function rk2_lc
        (
            lc     : lc_record;
            l_gain : real;
            c_gain : real;
            r_l    : real;
            r_load : real;
            input_voltage : real;
            load_current  : real
        )
        return  lc_record
        is
            variable k_lc : lc_array;
            variable retval : lc_record;
        begin
            k_lc(1) := calculate_lc((lc.current                   , lc.voltage)                   , l_gain , c_gain , r_l , r_load , input_voltage , load_current);
            k_lc(2) := calculate_lc((lc.current + k_lc(1).current , lc.voltage + k_lc(1).voltage) , l_gain , c_gain , r_l , r_load , input_voltage , load_current);

            retval.current := lc.current + k_lc(2).current;
            retval.voltage := lc.voltage + k_lc(2).voltage;

            return retval;
            
        end rk2_lc;

    ------------------------------
        variable k1_i3 : real := 0.0;
        variable k2_i3 : real := 0.0;
        variable k3_i3 : real := 0.0;
        variable k4_i3 : real := 0.0;

        variable k1_dc_link : real := 0.0;
        variable k2_dc_link : real := 0.0;
        variable k3_dc_link : real := 0.0;
        variable k4_dc_link : real := 0.0;

        file file_handler : text open write_mode is "supply_model_tb.dat";
    begin
        if rising_edge(simulator_clock) then
            simulation_counter <= simulation_counter + 1;
            if simulation_counter = 0 then
                init_simfile(file_handler, ("time", "volt", "curr", "load", "dcur"));
            end if;

            case sequencer is
                when 0 =>

                    lc1 <= rk2_lc(lc1 , l , c , r , 0.00 , uin-lc1.voltage , lc2.current);
                    lc2 <= rk2_lc(lc2 , l , c , r , 0.00 , lc1.voltage , duty*i3);

                    k1_i3 := (lc2.voltage - dc_link*duty)*timestep/1.0e-3;
                    k2_i3 := (lc2.voltage - dc_link*duty)*timestep/1.0e-3;

                    k1_dc_link := (duty*i3 - dc_link/load_r)*timestep/1.0e-3;
                    k2_dc_link := (duty*i3 - (dc_link + k1_dc_link)/load_r)*timestep/1.0e-3;

                    i3 <= i3 + k2_i3;
                    dc_link <= dc_link + k2_dc_link;
                    realtime <= realtime + timestep;
                    write_to(file_handler,(realtime, dc_link, lc2.current, dc_link/load_r, -duty*i3));

                when others => --do nothing
            end case;

            if realtime > 40.0e-3 then load_r <= 0.5; end if;
            if realtime > 15.0e-3 then duty   <= 0.4; end if;
            if realtime > 30.0e-3 then duty   <= 0.6; end if;
            if realtime > 60.0e-3 then uin    <= 0.6; end if;

            sequencer <= sequencer + 1;
            if sequencer > 0 then
                sequencer <= 0;
            end if;

        end if; -- rising_edge
    end process stimulus;	
------------------------------------------------------------------------
end vunit_simulation;
