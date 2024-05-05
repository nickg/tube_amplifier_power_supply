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

proc add_vhdl_file_to_project {vhdl_file} {
    read_vhdl -vhdl2008 $vhdl_file
}

proc add_vhdl_file_to_library {vhdl_file library} {
    read_vhdl -vhdl2008 -library $library $vhdl_file 
}

proc set_3v3_io {pin_name_from_port package_pin_location} {
    set_property IOSTANDARD LVCMOS33 [get_ports *$pin_name_from_port*]
    place_ports *$pin_name_from_port* $package_pin_location
}

source $tcl_path/program_functions.tcl
