library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

package llc_modulator_pkg is
    type hb_llc_pwm is record
        pri_high : std_logic;
        pri_low : std_logic;
        sync1 : std_logic;
        sync2 : std_logic;
    end record;

    type llc_modulator_clock_group is record
        modulator_clock : std_logic;
        core_clock : std_logic;
    end record;
    
    type llc_modulator_FPGA_output_group is record
        llc_gates : hb_llc_pwm;
    end record;
    
    type llc_modulator_data_input_group is record
        tg_trigger_llc_period : std_logic;
        deadtime : integer range 0 to 2**12-1;
        period : integer range 0 to 2**12-1;
        llc_is_enabled : boolean;
    end record;
    
    type llc_modulator_data_output_group is record
        clock : std_logic;
    end record;
    
    component llc_modulator is
        port (
            llc_modulator_clocks : in llc_modulator_clock_group; 
            llc_modulator_FPGA_out : out llc_modulator_FPGA_output_group; 
            llc_modulator_data_in : in llc_modulator_data_input_group;
            llc_modulator_data_out : out llc_modulator_data_output_group
        );
    end component llc_modulator;

    constant llc_min_period : integer := 474;
    constant llc_max_period : integer := 853;
        
------------------------------------------------------------------------
    procedure set_period ( period : in integer;
        signal llc_input : inout llc_modulator_data_input_group);
------------------------------------------------------------------------         
    procedure enable_llc_modulator (
        signal llc_input : out llc_modulator_data_input_group);
------------------------------------------------------------------------         
    procedure disable_llc_modulator (
        signal llc_input : inout llc_modulator_data_input_group);
------------------------------------------------------------------------         
    procedure set_deadtime ( deadtime : in integer;
        signal llc_input : inout llc_modulator_data_input_group);
------------------------------------------------------------------------         
    procedure trigger_modulator_changes (
        signal llc_input : inout llc_modulator_data_input_group);
------------------------------------------------------------------------         
end package llc_modulator_pkg;

package body llc_modulator_pkg is
------------------------------------------------------------------------
    procedure trigger_modulator_changes
    (
        signal llc_input : inout llc_modulator_data_input_group
    ) is
    begin
        llc_input.tg_trigger_llc_period <= not llc_input.tg_trigger_llc_period;
    end trigger_modulator_changes;
------------------------------------------------------------------------
    procedure set_period ( period : in integer;
        signal llc_input : inout llc_modulator_data_input_group
    )
    is
    begin
        llc_input.period <= period;
    end set_period;
------------------------------------------------------------------------
    procedure set_deadtime ( deadtime : in integer;
        signal llc_input : inout llc_modulator_data_input_group
    )
    is
    begin
        llc_input.deadtime <= deadtime;
    end set_deadtime;
------------------------------------------------------------------------
    procedure enable_llc_modulator ( 
        signal llc_input : out llc_modulator_data_input_group
    ) is
    begin
        llc_input.llc_is_enabled <= true;
    end enable_llc_modulator;
------------------------------------------------------------------------
    procedure disable_llc_modulator ( 
        signal llc_input : inout llc_modulator_data_input_group
    ) is
    begin
        llc_input.llc_is_enabled <= false;
        set_period(474,llc_input);
        trigger_modulator_changes(llc_input);
    end disable_llc_modulator;
------------------------------------------------------------------------

end package body llc_modulator_pkg;
