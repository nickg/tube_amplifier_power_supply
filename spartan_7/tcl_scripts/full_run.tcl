#Define target part and create output directory
variable tcl_path [ file dirname [ file normalize [ info script ] ] ] 

set outputDir ./output
file mkdir $outputDir
set source_folder $tcl_path/../../source

set files [glob -nocomplain "$outputDir/*"]
if {[llength $files] != 0} {
    # clear folder contents
    puts "deleting contents of $outputDir"
    file delete -force {*}[glob -directory $outputDir *]; 
} else {
    puts "$outputDir is empty"
}

set target_device xc7s15ftgb196-2
create_project -force -in_memory tube_psu_v5

set_property part $target_device [current_project]
set_property target_language VHDL [current_project]

    proc add_vhdl_file_to_project {vhdl_file} {
        read_vhdl -vhdl2008 $vhdl_file
    }

    proc add_vhdl_file_to_library {vhdl_file library} {
        read_vhdl -vhdl2008 -library $library $vhdl_file 
    }



source $tcl_path/read_sources.tcl


synth_design
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
# #VCCO(zero) = IO = 2.5V || 3.3V, GND IO bank0 = 1.8v
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property BITSTREAM.Config.SPI_BUSWIDTH 4 [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 33 [current_design]

write_bitstream -force hvhdl_example_project_ram_image.bit
write_cfgmem -force  -format mcs -size 2 -interface SPIx4        \
    -loadbit "up 0x0 hvhdl_example_project_ram_image.bit" \
    -file "hvhdl_example_project_flash_image.mcs"
