add_vhdl_file_to_project $source_folder/top/system_clocks_pkg.vhd

add_vhdl_file_to_project $source_folder/dsp/multiplier/multiplier_pkg.vhd 
add_vhdl_file_to_project $source_folder/dsp/multiplier/multiplier_body.vhd
add_vhdl_file_to_project $source_folder/dsp/multiplier/multiplier.vhd     
add_vhdl_file_to_project $source_folder/dsp/sincos/sincos_pkg.vhd         
add_vhdl_file_to_project $source_folder/dsp/sincos/sincos.vhd             

add_vhdl_file_to_project $source_folder/dsp/feedback_control/feedback_control_pkg.vhd
add_vhdl_file_to_project $source_folder/dsp/feedback_control/feedback_control.vhd

add_vhdl_file_to_library $source_folder/common/timing/timing_pkg.vhd                   common_library
add_vhdl_file_to_library $source_folder/common/timing/delay_timer.vhd                  common_library
add_vhdl_file_to_library $source_folder/common/typesdefs/typedefs_pkg.vhd              common_library
add_vhdl_file_to_library $source_folder/common/register_shifts/register_shifts_pkg.vhd common_library

add_vhdl_file_to_project $source_folder/top/system_control/component_interconnect/ext_ad/spi3w_ads7056_driver.vhd 
add_vhdl_file_to_project $source_folder/top/system_control/component_interconnect/ext_ad/ext_ad_spi3w.vhd 

add_vhdl_file_to_library $source_folder/top/system_control/component_interconnect/measurement_interface/onboard_ad_control/onboard_ad_control_pkg.vhd          onboard_adc_library
add_vhdl_file_to_library $source_folder/top/system_control/component_interconnect/measurement_interface/onboard_ad_control/onboard_ad_control_internal_pkg.vhd onboard_adc_library
add_vhdl_file_to_library $source_folder/top/system_control/component_interconnect/measurement_interface/onboard_ad_control/onboard_ad_control.vhd              onboard_adc_library
add_vhdl_file_to_library $source_folder/top/system_control/component_interconnect/measurement_interface/measurement_interface_pkg.vhd                          onboard_adc_library
add_vhdl_file_to_library $source_folder/top/system_control/component_interconnect/measurement_interface/measurement_interface.vhd                              onboard_adc_library
add_vhdl_file_to_library $source_folder/top/system_control/component_interconnect/measurement_interface/psu_measurement_interface_pkg.vhd                      onboard_adc_library

add_vhdl_file_to_project $source_folder/top/system_control/led_driver/led_driver_pkg.vhd 
add_vhdl_file_to_project $source_folder/top/system_control/led_driver/led_driver.vhd 

add_vhdl_file_to_project $source_folder/top/system_control/component_interconnect/power_supply_control/dhb_control/phase_modulator/deadtime_pkg.vhd
add_vhdl_file_to_project $source_folder/top/system_control/component_interconnect/power_supply_control/dhb_control/phase_modulator/deadtime.vhd
add_vhdl_file_to_project $source_folder/top/system_control/component_interconnect/power_supply_control/dhb_control/phase_modulator/phase_modulator_pkg.vhd
add_vhdl_file_to_project $source_folder/top/system_control/component_interconnect/power_supply_control/dhb_control/phase_modulator/phase_modulator.vhd
add_vhdl_file_to_project $source_folder/top/system_control/component_interconnect/power_supply_control/dhb_control/dhb_control_pkg.vhd
add_vhdl_file_to_project $source_folder/top/system_control/component_interconnect/power_supply_control/dhb_control/dhb_control.vhd

add_vhdl_file_to_project $source_folder/top/system_control/component_interconnect/power_supply_control/llc_control/llc_modulator/llc_modulator_pkg.vhd
add_vhdl_file_to_project $source_folder/top/system_control/component_interconnect/power_supply_control/llc_control/llc_modulator/llc_modulator.vhd
add_vhdl_file_to_project $source_folder/top/system_control/component_interconnect/power_supply_control/llc_control/llc_control_pkg.vhd
add_vhdl_file_to_project $source_folder/top/system_control/component_interconnect/power_supply_control/llc_control/llc_control_internal_pkg.vhd
add_vhdl_file_to_project $source_folder/top/system_control/component_interconnect/power_supply_control/llc_control/arch_llc_pi_control.vhd
add_vhdl_file_to_project $source_folder/top/system_control/component_interconnect/power_supply_control/llc_control/llc_control.vhd

add_vhdl_file_to_project $source_folder/top/system_control/component_interconnect/power_supply_control/pfc_control/pfc_modulator/pfc_modulator_pkg.vhd
add_vhdl_file_to_project $source_folder/top/system_control/component_interconnect/power_supply_control/pfc_control/pfc_modulator/pfc_modulator.vhd
add_vhdl_file_to_project $source_folder/top/system_control/component_interconnect/power_supply_control/pfc_control/pfc_control_pkg.vhd
add_vhdl_file_to_project $source_folder/top/system_control/component_interconnect/power_supply_control/pfc_control/arch_pfc_current_control.vhd
add_vhdl_file_to_project $source_folder/top/system_control/component_interconnect/power_supply_control/pfc_control/arch_pfc_voltage_control.vhd
add_vhdl_file_to_project $source_folder/top/system_control/component_interconnect/power_supply_control/pfc_control/pfc_control.vhd

add_vhdl_file_to_project $source_folder/top/system_control/component_interconnect/power_supply_control/power_supply_control_pkg.vhd
add_vhdl_file_to_project $source_folder/top/system_control/component_interconnect/power_supply_control/power_supply_control.vhd

add_vhdl_file_to_project $source_folder/top/system_control/component_interconnect/component_interconnect_pkg.vhd
add_vhdl_file_to_project $source_folder/top/system_control/component_interconnect/component_interconnect.vhd

add_vhdl_file_to_project $source_folder/top/system_control/system_control_pkg.vhd 
add_vhdl_file_to_project $source_folder/top/system_control/system_control_internal_pkg.vhd 
add_vhdl_file_to_project $source_folder/top/system_control/system_control.vhd 

