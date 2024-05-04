# read vhdl files
read_vhdl -vhdl2008 [ glob $tcl_path/../s7_source/s7_adc_wrapper.vhd]
read_vhdl -vhdl2008 [ glob $tcl_path/../s7_source/s7_specifics.vhd]
read_vhdl -vhdl2008 [ glob $tcl_path/../s7_source/s7_multiplier_wrapper.vhd]
read_vhdl -vhdl2008 [ glob $tcl_path/../s7_source/s7_pll_wrapper.vhd]

read_vhdl -vhdl2008 [ glob $source_folder/top/top.vhd ]

source $source_folder/../list_of_sources.tcl

source $tcl_path/ipgen_main_pll.tcl
source $tcl_path/ipgen_mult_18x18.tcl
# source $tcl_path/ipgen_ab_sum_c.tcl

read_xdc $tcl_path/../constraints/constraints.xdc
