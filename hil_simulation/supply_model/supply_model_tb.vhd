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

    type lc_record is record
        current : real;
        voltage : real;
    end record;

    type pfc_record is record
        lc1     : lc_record;
        lc2     : lc_record;
        i3      : real;
        dc_link : real;
    end record;

    signal pfc : pfc_record := (
        (others => 0.0) ,
        (others => 0.0) ,
        0.0             ,
        150.0);

    signal duty    : real := 0.5;
    signal load_r  : real := 100.0;

    signal r        : real := 150.0e-3;
    signal l        : real := timestep/15.0e-6;
    signal c        : real := timestep/1.0e-6;
    signal uin      : real := 100.0;

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
        impure function calculate_pfc
        (
            self : pfc_record;
            l_gain : real;
            c_gain : real;
            r_l : real;
            r_load : real;
            input_voltage : real;
            load_current : real
        )
        return pfc_record
        is
            variable retval : pfc_record;
        begin

            retval.lc1     := calculate_lc((pfc.lc1.current , pfc.lc1.voltage) , l , c , r , 0.0 , uin         , pfc.lc2.current);
            retval.lc2     := calculate_lc((pfc.lc2.current , pfc.lc2.voltage) , l , c , r , 0.0 , pfc.lc1.voltage , duty*pfc.i3);
            retval.i3      := (pfc.lc2.voltage - pfc.dc_link*duty)*timestep/1.0e-3;
            retval.dc_link := (duty*pfc.i3 - pfc.dc_link/load_r)*timestep/1.0e-3;

            return retval;

            return retval;
        end calculate_pfc;
    ------------------------------
        type pfc_array is array (integer range 1 to 2) of pfc_record;
        variable k_pfc : pfc_array;

        file file_handler : text open write_mode is "supply_model_tb.dat";

    begin
        if rising_edge(simulator_clock) then
            simulation_counter <= simulation_counter + 1;
            if simulation_counter = 0 then
                init_simfile(file_handler, ("time", "volt", "curr", "load", "dcur"));
            end if;

            case sequencer is
                when 0 =>
                    k_pfc(1).lc1     := calculate_lc((pfc.lc1.current , pfc.lc1.voltage) , l , c , r , 0.0 , uin         , pfc.lc2.current);
                    k_pfc(1).lc2     := calculate_lc((pfc.lc2.current , pfc.lc2.voltage) , l , c , r , 0.0 , pfc.lc1.voltage , duty*pfc.i3);
                    k_pfc(1).i3      := (pfc.lc2.voltage - pfc.dc_link*duty)*timestep/1.0e-3;
                    k_pfc(1).dc_link := (duty*pfc.i3 - pfc.dc_link/load_r)*timestep/1.0e-3;
                    -- k_pfc(1) := calculate_pfc(

                    k_pfc(2).lc1     := calculate_lc((pfc.lc1.current + k_pfc(1).lc1.current/2.0  , pfc.lc1.voltage + k_pfc(1).lc1.voltage/2.0)  , l , c , r , 0.0 , uin                               , pfc.lc2.current + k_pfc(1).lc2.current/2.0);
                    k_pfc(2).lc2     := calculate_lc((pfc.lc2.current + k_pfc(1).lc2.current/2.0 , pfc.lc2.voltage + k_pfc(1).lc2.voltage/2.0) , l , c , r , 0.0 , pfc.lc1.voltage + k_pfc(1).lc1.voltage/2.0 , duty*(pfc.i3 + k_pfc(1).i3/2.0));
                    k_pfc(2).i3      := ((pfc.lc2.voltage + k_pfc(1).lc2.voltage/2.0) - (pfc.dc_link + k_pfc(1).dc_link)*duty)*timestep/1.0e-3;
                    k_pfc(2).dc_link := (duty*(pfc.i3 + k_pfc(1).i3/2.0) - (pfc.dc_link + k_pfc(1).dc_link/2.0)/load_r)*timestep/1.0e-3;

                    pfc.lc1     <= (pfc.lc1.current + k_pfc(2).lc1.current  , pfc.lc1.voltage + k_pfc(2).lc1.voltage);
                    pfc.lc2     <= (pfc.lc2.current + k_pfc(2).lc2.current , pfc.lc2.voltage + k_pfc(2).lc2.voltage);
                    pfc.i3      <= pfc.i3 + k_pfc(2).i3;
                    pfc.dc_link <= pfc.dc_link + k_pfc(2).dc_link;

                    realtime <= realtime + timestep;
                    write_to(file_handler,(realtime, pfc.dc_link, pfc.lc2.current, pfc.dc_link/load_r, -duty*pfc.i3));

                when others => --do nothing
            end case;

            -- if realtime > 15.0e-3 then duty   <= 0.4; end if;
            if realtime > 30.0e-3 then duty   <= 0.4; end if;
            -- if realtime > 40.0e-3 then load_r <= 50.0; end if;
            -- if realtime > 60.0e-3 then uin    <= 0.6; end if;

            sequencer <= sequencer + 1;
            if sequencer > 0 then
                sequencer <= 0;
            end if;

        end if; -- rising_edge
    end process stimulus;	
------------------------------------------------------------------------
end vunit_simulation;
