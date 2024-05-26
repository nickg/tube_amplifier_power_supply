LIBRARY ieee  ; 
    USE ieee.NUMERIC_STD.all  ; 
    USE ieee.std_logic_1164.all  ; 
    use ieee.math_real.all;

library vunit_lib;
context vunit_lib.vunit_context;

entity dhb_modulator_tb is
  generic (runner_cfg : string);
end;

architecture vunit_simulation of dhb_modulator_tb is

    constant clock_period      : time    := 1 ns;
    constant simtime_in_clocks : integer := 5000;
    
    signal simulator_clock     : std_logic := '0';
    signal simulation_counter  : natural   := 0;
    -----------------------------------
    -- simulation specific signals ----
    procedure get_pwm
    (
        carrier     : in integer;
        carrier_max : in integer;
        phase       : in integer;
        signal pwm  : inout std_logic
    )
    is
        variable phased_carrier : integer;
    begin
        phased_carrier := carrier + phase;
        if (phased_carrier < carrier_max/2-carrier_max/4) or (phased_carrier > carrier_max/2+carrier_max/4) then
            pwm <= '0';
        else
            pwm <= '1';
        end if;
        
    end get_pwm;

    signal carrier : natural range 0 to 2047 := 0;
    signal phase_shifted_carrier : natural range 0 to 2047 := 0;

    signal pri_pwm : std_logic := '0';
    signal sec_pwm : std_logic := '0';

    signal phase : integer range -1000 to 1000 := 0;
    signal carrier_max : natural := 500;

begin

------------------------------------------------------------------------
    simtime : process
    begin
        test_runner_setup(runner, runner_cfg);
        wait for simtime_in_clocks*clock_period;
        test_runner_cleanup(runner); -- Simulation ends here
        wait;
    end process simtime;	

    simulator_clock <= not simulator_clock after clock_period/2.0;
------------------------------------------------------------------------

    stimulus : process(simulator_clock)
    begin
        if rising_edge(simulator_clock) then
            simulation_counter <= simulation_counter + 1;

            if carrier < carrier_max then
                carrier <= carrier + 1;
            else
                carrier <= 0;
            end if;

            get_pwm(carrier , carrier_max , -phase , pri_pwm);
            get_pwm(carrier , carrier_max ,  phase , sec_pwm);

            CASE simulation_counter is
                WHEN 1105      => phase <= 500/8;
                WHEN 2070 + 40 => phase <= -500/8;
                WHEN others    =>
            end CASE;

        end if; -- rising_edge
    end process stimulus;	
------------------------------------------------------------------------
    ddr_simulaition : process(simulator_clock)
    begin
        if rising_edge(simulator_clock) then
        end if; --rising_edge

        if falling_edge(simulator_clock) then
        end if; --falling edge
    end process ddr_simulaition;	
------------------------------------------------------------------------
end vunit_simulation;
