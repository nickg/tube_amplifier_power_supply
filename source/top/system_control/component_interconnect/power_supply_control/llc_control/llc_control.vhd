library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

library onboard_adc_library;
    use onboard_adc_library.onboard_ad_control_pkg.all;

library work;
    use work.llc_control_pkg.all;
    use work.llc_modulator_pkg.all;
    use work.multiplier_pkg.all;

entity llc_control is
    port (
        llc_control_clocks : in llc_control_clock_group;
        llc_control_FPGA_out : out llc_control_FPGA_output_group;
        llc_control_data_in : in llc_control_data_input_group;
        llc_control_data_out : out llc_control_data_output_group
    );
end llc_control;

architecture rtl of llc_control is

    alias core_clock : std_logic is llc_control_clocks.core_clock;
    alias modulator_clock : std_logic is llc_control_clocks.modulator_clock;
------------------------------------------------------------------------
    signal multiplier_clocks   : multiplier_clock_group;
    signal multiplier_data_in  : multiplier_data_input_group;
    signal multiplier_data_out :  multiplier_data_output_group;
------------------------------------------------------------------------
    signal llc_modulator_clocks   : llc_modulator_clock_group;
    signal llc_modulator_data_in  : llc_modulator_data_input_group;
    signal llc_modulator_data_out : llc_modulator_data_output_group;
------------------------------------------------------------------------
begin
------------------------------------------------------------------------
    multiplier_clocks.dsp_clock <= core_clock;
    u_multiplier : multiplier
        port map(
            multiplier_clocks, 
            multiplier_data_in,
            multiplier_data_out 
        );
------------------------------------------------------------------------
    llc_modulator_clocks <= (core_clock => core_clock, modulator_clock => modulator_clock);
    u_llc_modulator : llc_modulator
    port map
    (
        llc_modulator_clocks,
        llc_control_FPGA_out.llc_modulator_FPGA_out,
        llc_modulator_data_in, 
        llc_modulator_data_out
    );
------------------------------------------------------------------------
end rtl;
