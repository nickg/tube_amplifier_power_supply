LIBRARY ieee  ; 
    USE ieee.NUMERIC_STD.all  ; 
    USE ieee.std_logic_1164.all  ; 
    use std.textio.all;
    use ieee.math_real.all;

library vunit_lib;
context vunit_lib.vunit_context;

    use work.write_pkg.all;
    use work.pfc_model_pkg.all;

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
    constant timestep : real := 2.0e-6;

    signal sequencer : natural := 1;

    signal pfc : pfc_record := (
        (others => 0.0) ,
        (others => 0.0) ,
        0.0             ,
        150.0);

    signal duty   : real := 0.5;
    signal load_r : real := 100.0;

    signal r            : real := 150.0e-3;
    signal l            : real := timestep/5.5e-6;
    signal c            : real := timestep/0.68e-6;
    signal dc_link_gain : real := timestep/1.0e-3;
    signal pri_l_gain   : real := timestep/3.0e-3;
    signal uin          : real := 100.0;

    signal load : real := 0.0;

begin

------------------------------------------------------------------------
    simtime : process
    begin
        test_runner_setup(runner, runner_cfg);
        wait until realtime >= 100.0e-3;
        test_runner_cleanup(runner); -- Simulation ends here
        wait;
    end process simtime;	

    simulator_clock <= not simulator_clock after clock_period/2.0;
------------------------------------------------------------------------

    stimulus : process(simulator_clock)
    ------------------------------
    ------------------------------
        type pfc_array is array (natural range <>) of pfc_record;
        variable k_pfc : pfc_array(1 to 4);

        file file_handler : text open write_mode is "supply_model_tb.dat";

        function calculate_pfc
        (
            self          : pfc_record;
            l_gain        : real ;
            c_gain        : real ;
            dc_link_gain  : real ;
            pri_l_gain    : real ;
            r_l           : real ;
            r_load        : real ;
            input_voltage : real ;
            load_current  : real ;
            duty          : real range -1.0 to 1.0
        )
        return pfc_record
        is
            variable retval : pfc_record := self;
            variable sum : real_vector(0 to 7);
            variable mult_add : real_vector(0 to 7);
            variable mult : real_vector(0 to 9);
        begin

            sum(1) := self.lc1.current - self.lc2.current;
            sum(3) := self.lc2.current - self.i3;
            sum(0) := input_voltage - self.lc1.voltage;
            sum(2) := self.lc1.voltage - self.lc2.voltage;
            mult(0) := - r_l*self.lc1.current;
            mult(1) := r_load * self.lc2.current;
            mult(2) := - r_l*self.lc2.current;
            mult(3) := r_load * self.i3;
            mult_add(0) := self.lc2.voltage - self.dc_link*duty;
            mult_add(1) := duty*self.i3 - load_current;

            mult(4) := (sum(1))*c_gain;
            mult(5) := (sum(3))*c_gain;
            mult(6) := sum(0)*l_gain;
            mult(7) := sum(2) * l_gain;
            sum(4) := mult(0) + mult(1);
            sum(5) := mult(2) + mult(3);
            mult_add(2) := mult(6) + (sum(4)) * l_gain;
            mult_add(3) := mult(7) + (sum(5)) * l_gain;
            mult(8) := mult_add(0)*pri_l_gain;
            mult(9) := mult_add(1)*dc_link_gain;

            retval.lc1.current := mult_add(2);
            retval.lc1.voltage := mult(4);

            retval.lc2.current := mult_add(3);
            retval.lc2.voltage := mult(5);

            retval.i3      := mult(8);
            retval.dc_link := mult(9);

            return retval;
        end calculate_pfc;

    begin
        if rising_edge(simulator_clock) then
            simulation_counter <= simulation_counter + 1;
            if simulation_counter = 0 then
                init_simfile(file_handler, ("time", "volt", "curr", "load", "dcur"));
            end if;

            case sequencer is
                when 0 =>
                    k_pfc(1) := calculate_pfc(pfc                , l , c , dc_link_gain , pri_l_gain , r , 0.0 , uin , pfc.dc_link/load_r , duty);
                    k_pfc(2) := calculate_pfc(pfc + k_pfc(1)/2.0 , l , c , dc_link_gain , pri_l_gain , r , 0.0 , uin , pfc.dc_link/load_r , duty);
                    k_pfc(3) := calculate_pfc(pfc + k_pfc(2)/2.0 , l , c , dc_link_gain , pri_l_gain , r , 0.0 , uin , pfc.dc_link/load_r , duty);
                    k_pfc(4) := calculate_pfc(pfc + k_pfc(3)     , l , c , dc_link_gain , pri_l_gain , r , 0.0 , uin , pfc.dc_link/load_r , duty);

                    pfc <= pfc + (k_pfc(1) + k_pfc(2)/0.5 + k_pfc(3)/0.5 + k_pfc(4))/6.0;
                    -- pfc <= pfc + k_pfc(1);

                    realtime <= realtime + timestep;
                    write_to(file_handler,(realtime, pfc.dc_link, pfc.lc2.current, pfc.dc_link/load_r, -duty*pfc.i3));

                when others => --do nothing
            end case;

            -- if realtime > 15.0e-3 then duty   <= 0.4; end if;
            if realtime > 50.0e-3 then duty   <= 0.8; end if;
            -- if realtime > 80.0e-3 then load_r <= 10.0; end if;
            -- if realtime > 60.0e-3 then uin    <= 0.6; end if;

            sequencer <= sequencer + 1;
            if sequencer > 0 then
                sequencer <= 0;
            end if;

        end if; -- rising_edge
    end process stimulus;	
------------------------------------------------------------------------
end vunit_simulation;
