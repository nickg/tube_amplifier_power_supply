variable tcl_path [ file dirname [ file normalize [ info script ] ] ] 

source $tcl_path/init_build_environment.tcl

set target_device xc7s15ftgb196-2
create_project -force -in_memory tube_psu_v5
set_property target_language VHDL [current_project]
set_property part $target_device [current_project]

add_vhdl_file_to_project $tcl_path/../s7_source/s7_adc_wrapper.vhd
add_vhdl_file_to_project $tcl_path/../s7_source/s7_specifics.vhd
add_vhdl_file_to_project $tcl_path/../s7_source/s7_multiplier_wrapper.vhd
add_vhdl_file_to_project $tcl_path/../s7_source/s7_pll_wrapper.vhd

source $source_folder/../list_of_sources.tcl

source $tcl_path/ip_generation/ipgen_main_pll.tcl
source $tcl_path/ip_generation/ipgen_mult_18x18.tcl

add_vhdl_file_to_project $source_folder/top/s7_top.vhd
set_property top top [current_fileset]

synth_design

set_3v3_io xclk             H11
set_3v3_io ada_clock        A13
set_3v3_io ada_cs           B14
set_3v3_io adb_clock        D14
set_3v3_io adb_cs           E13
set_3v3_io ada_data         C14
set_3v3_io adb_data         F13
set_3v3_io \[adb_mux\]\[0\] B6
set_3v3_io \[adb_mux\]\[1\] A5
set_3v3_io \[adb_mux\]\[2\] B5
set_3v3_io \[ada_mux\]\[0\] B13
set_3v3_io \[ada_mux\]\[1\] A12
set_3v3_io \[ada_mux\]\[2\] A10
set_3v3_io bypass_relay     H1
set_3v3_io uart_tx          D2
set_3v3_io uart_rx          E2
set_3v3_io llc_ad_cs        P2
set_3v3_io llc_ad_data      L2
set_3v3_io llc_ad_clock     J1
set_3v3_io dhb_ad_cs        M3
set_3v3_io dhb_ad_data      J2
set_3v3_io dhb_ad_clock     L1


set_3v3_io \[po3_led1\]\[red\]         F14
set_3v3_io \[po3_led1\]\[blue\]        D13
set_3v3_io \[po3_led1\]\[green\]       G14
set_3v3_io \[po3_led2\]\[red\]         H14
set_3v3_io \[po3_led2\]\[blue\]        H13
set_3v3_io \[po3_led2\]\[green\]       J12
set_3v3_io \[po3_led3\]\[red\]         J13
set_3v3_io \[po3_led3\]\[blue\]        J14
set_3v3_io \[po3_led3\]\[green\]       L14

# pfc gates
set_3v3_io ac1_switch          G1 
set_3v3_io ac2_switch          A4 

# dhb gates
set_3v3_io \[primary\]\[high_gate\]     P5 
set_3v3_io \[primary\]\[low_gate\]      P4 
set_3v3_io \[secondary\]\[high_gate\]     N1 
set_3v3_io \[secondary\]\[low_gate\]      M1 

# llc gates
set_3v3_io pri_high      P3 
set_3v3_io pri_low       N4 
set_3v3_io sync1         M2 
set_3v3_io sync2         L3 


write_checkpoint -force $outputDir/post_synth.dcp
report_timing_summary -file $outputDir/post_synth_timing_summary.rpt
report_utilization -file $outputDir/post_synth_util.rpt

opt_design
place_design
report_clock_utilization -file $outputDir/clock_util.rpt

#get timing violations and run optimizations if needed
 if {[get_property SLACK [get_timing_paths -max_paths 1 -nworst 1 -setup]] < 0.1} {
  puts "Found setup timing violations => running physical optimization"
  phys_opt_design
 }
write_checkpoint -force $outputDir/post_place.dcp
report_utilization -file $outputDir/post_place_util.rpt
report_timing_summary -file $outputDir/post_place_timing_summary.rpt

#Route design and generate bitstream
route_design -directive Explore
write_checkpoint -force $outputDir/post_route.dcp

write_bit_and_flash_images tube_power
