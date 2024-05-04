# read vhdl files
add_vhdl_file_to_project $tcl_path/../s7_source/s7_adc_wrapper.vhd
add_vhdl_file_to_project $tcl_path/../s7_source/s7_specifics.vhd
add_vhdl_file_to_project $tcl_path/../s7_source/s7_multiplier_wrapper.vhd
add_vhdl_file_to_project $tcl_path/../s7_source/s7_pll_wrapper.vhd

source $source_folder/../list_of_sources.tcl

source $tcl_path/ipgen_main_pll.tcl
source $tcl_path/ipgen_mult_18x18.tcl
# source $tcl_path/ipgen_ab_sum_c.tcl

read_xdc $tcl_path/../constraints/constraints.xdc

add_vhdl_file_to_project $source_folder/top/s7_top.vhd
set_property top top [current_fileset]
