LIBRARY ieee  ; 
    USE ieee.NUMERIC_STD.all  ; 
    USE ieee.std_logic_1164.all  ; 

package dhb_modulator_pkg is

    subtype dhb_int is integer range -2**11 to 2**11-1;

    type pwm_record is record
        buffered_phase   : dhb_int;
        phase            : dhb_int;
        carrier_buf      : dhb_int;
        low_level        : boolean;
        high_level       : boolean;
        low_to_high_edge : dhb_int;
        high_to_low_edge : dhb_int;
        phased_carrier   : dhb_int;
        ontime_in_clocks : dhb_int;
        carrier_max      : dhb_int;
        carrier_max_buf  : dhb_int;
    end record;

    constant init_pwm : pwm_record := (0, 0, 0, false, false, 0, 0, 0, 0, 500, 500);

    procedure create_dhb_pwm (
        signal self      : inout pwm_record;
        carrier          : in integer;
        carrier_max      : in integer;
        ontime_in_clocks : in integer;
        phase            : in integer;
        signal pwm       : inout std_logic);

    procedure set_phase (
        signal self : inout pwm_record;
        phase : in integer);

    procedure set_ontime (
        signal self : inout pwm_record;
        ontime      : integer);

    procedure set_carrier_max (
        signal self : inout pwm_record;
        carrier_max : integer);

end package dhb_modulator_pkg;

package body dhb_modulator_pkg is

    procedure create_dhb_pwm
    (
        signal self      : inout pwm_record;
        carrier          : in integer;
        carrier_max      : in integer;
        ontime_in_clocks : in integer;
        phase            : in integer;
        signal pwm       : inout std_logic
    )
    is
    begin
        self.carrier_buf      <= carrier;
        if self.carrier_buf = 0 or self.carrier_buf = self.carrier_max/2 then
            self.phase            <= self.buffered_phase;
            self.ontime_in_clocks <= ontime_in_clocks;
        end if;

        if self.carrier_buf = 0 then
            self.carrier_max_buf <= self.carrier_max;
        end if;

        self.phased_carrier   <= self.carrier_buf + self.phase;
        self.low_to_high_edge <= self.carrier_max_buf/2-self.ontime_in_clocks/2;
        self.high_to_low_edge <= self.carrier_max_buf/2+self.ontime_in_clocks/2;

        self.low_level  <= (self.phased_carrier < self.low_to_high_edge);
        self.high_level <= (self.phased_carrier > self.high_to_low_edge);

        if self.low_level or self.high_level then
            pwm <= '0';
        else
            pwm <= '1';
        end if;
        
    end create_dhb_pwm;

    procedure set_phase
    (
        signal self : inout pwm_record;
        phase : in integer
    ) is
    begin
        self.buffered_phase <= phase;
    end set_phase;

    procedure set_ontime
    (
        signal self : inout pwm_record;
        ontime      : integer
    ) is
    begin
        self.ontime_in_clocks <= ontime;
    end set_ontime;

    procedure set_carrier_max
    (
        signal self : inout pwm_record;
        carrier_max : integer
    ) is
    begin
        self.carrier_max <= carrier_max;
        
    end set_carrier_max;

end package body dhb_modulator_pkg;


--------------------------------------------------------
LIBRARY ieee  ; 
    USE ieee.NUMERIC_STD.all  ; 
    USE ieee.std_logic_1164.all  ; 
    use ieee.math_real.all;

    use work.dhb_modulator_pkg.all;

library vunit_lib;
context vunit_lib.vunit_context;

entity dhb_modulator_tb is
  generic (runner_cfg : string);
end;

architecture vunit_simulation of dhb_modulator_tb is

    constant clock_period      : time    := 1 ns;
    constant simtime_in_clocks : integer := 8000;
    
    signal simulator_clock     : std_logic := '0';
    signal simulation_counter  : natural   := 0;
    -----------------------------------
    -- simulation specific signals ----

    signal carrier : natural range 0 to 2047 := 0;
    signal phase_shifted_carrier : natural range 0 to 2047 := 0;

    signal pri_pwm : std_logic := '0';
    signal sec_pwm : std_logic := '0';

    signal phase : integer range -1000 to 1000 := 0;
    signal carrier_max : natural := 500;
    signal self1 : pwm_record := init_pwm;
    signal self2 : pwm_record := init_pwm;

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
        function "*"
        (
            left : integer; right : real
        )
        return integer
        is
        begin
            return integer(real(left)*right);
        end "*";
    begin
        if rising_edge(simulator_clock) then
            simulation_counter <= simulation_counter + 1;

            if carrier < carrier_max then
                carrier <= carrier + 1;
            else
                carrier <= 0;
            end if;

            set_carrier_max(self1, carrier_max);
            set_carrier_max(self2, carrier_max);
            create_dhb_pwm(self1 , carrier , carrier_max , (carrier_max*0.5) , -phase , pri_pwm);
            create_dhb_pwm(self2 , carrier , carrier_max , (carrier_max*0.5) , phase  , sec_pwm);

            CASE simulation_counter is
                WHEN 900      => 
                    set_phase(self1 , -carrier_max/8);
                    set_phase(self2 , carrier_max/8);

                WHEN 2070 + 40 => 
                    set_phase(self1 , carrier_max/8);
                    set_phase(self2 , -carrier_max/8);
                WHEN 2570 => 
                    set_phase(self1 , -carrier_max/8);
                    set_phase(self2 , carrier_max/8);

                WHEN 3509 => 
                    carrier_max <= 300;
                    set_phase(self1 , -300/8);
                    set_phase(self2 , 300/8);
                WHEN others    =>
            end CASE;

        end if; -- rising_edge
    end process stimulus;	
------------------------------------------------------------------------
end vunit_simulation;
