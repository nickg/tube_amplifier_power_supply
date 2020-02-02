library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

package onboard_ad_control_pkg is

    type muxed_ad_control is record
        ad_start_request_toggle : std_logic;
        ad_mux_position : integer range 0 to 7;
    end record;

    type onboard_ad_control_clock_group is record
        core_clock : std_logic;
        ad_clock : std_logic;
        reset_n : std_logic;
    end record;

    type onboard_ad_control_FPGA_input_group is record
        ada_data : std_logic;
        adb_data : std_logic;
    end record;

    type onboard_ad_control_FPGA_output_group is record
        ada_clock : std_logic;
        ada_cs : std_logic;
        ada_mux : std_logic_vector(2 downto 0);

        adb_clock : std_logic;
        adb_cs : std_logic;
        adb_mux : std_logic_vector(2 downto 0);
    end record;

    type onboard_ad_control_data_input_group is record
        ada_triggers : muxed_ad_control;
        adb_triggers : muxed_ad_control;
    end record;

    type onboard_ad_control_data_output_group is record
        ada_conversion_data : integer range 0 to 2**16-1;
        ada_data_is_ready : boolean;
        ada_channel : integer;

        adb_conversion_data : integer;
        adb_data_is_ready : boolean;
        adb_channel : integer;
    end record;

    component onboard_ad_control is
        port (
            onboard_ad_control_clocks : in onboard_ad_control_clock_group;

            onboard_ad_control_FPGA_in : in onboard_ad_control_FPGA_input_group;
            onboard_ad_control_FPGA_out : out onboard_ad_control_FPGA_output_group;

            onboard_ad_control_data_in : in onboard_ad_control_data_input_group;
            onboard_ad_control_data_out : out onboard_ad_control_data_output_group
        );
    end component onboard_ad_control;

------------------------------------------------------------------------
    procedure trigger_adc (signal adc_controls : inout muxed_ad_control; next_ad_channel : integer);
------------------------------------------------------------------------
    function adc_is_ready ( adc_data : onboard_ad_control_data_output_group; adc_channel : integer)
            return boolean;
------------------------------------------------------------------------
    function get_ada_measurement ( adc_data : onboard_ad_control_data_output_group) 
            return integer;
------------------------------------------------------------------------
end package onboard_ad_control_pkg;

package body onboard_ad_control_pkg is
------------------------------------------------------------------------
    procedure trigger_adc
    (
        signal adc_controls : inout muxed_ad_control;
        next_ad_channel : integer
    )
    is
        variable jee : muxed_ad_control;
    begin
        jee :=(ad_start_request_toggle => (not adc_controls.ad_start_request_toggle), ad_mux_position => next_ad_channel);
        adc_controls <= jee;
    end trigger_adc;
------------------------------------------------------------------------
    function adc_is_ready
    (
        adc_data : onboard_ad_control_data_output_group;
        adc_channel : integer
    )
    return boolean
    is
    begin
        return adc_data.ada_data_is_ready and adc_data.ada_channel = adc_channel;
    end adc_is_ready;
------------------------------------------------------------------------
        function get_ada_measurement
        (
            adc_data : onboard_ad_control_data_output_group
        )
        return integer
        is
        begin
            return adc_data.ada_conversion_data;
        end get_ada_measurement;
        ------------------------------------------------------------------------
end package body onboard_ad_control_pkg;
