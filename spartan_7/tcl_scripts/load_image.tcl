variable tcl_path [ file dirname [ file normalize [ info script ] ] ] 
source $tcl_path/init_build_environment.tcl

program_ram $argv

