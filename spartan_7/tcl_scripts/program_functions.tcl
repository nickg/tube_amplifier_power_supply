proc write_bit_and_flash_images {imagename} {

    # #VCCO(zero) = IO = 2.5V || 3.3V, GND IO bank0 = 1.8v
    set_property CFGBVS VCCO [current_design]
    set_property CONFIG_VOLTAGE 3.3 [current_design]
    set_property BITSTREAM.Config.SPI_BUSWIDTH 4 [current_design]
    set_property BITSTREAM.CONFIG.CONFIGRATE 33 [current_design]

    write_bitstream -force $imagename.bit
    write_cfgmem -force  -format mcs -size 2 -interface SPIx4        \
        -loadbit "up 0x0 ${imagename}.bit"\
        -file $imagename.mcs
}

proc program_ram {bitfile} {
    open_hw_manager
    connect_hw_server
    open_hw_target

    # Program and Refresh the Device

    current_hw_device [lindex [get_hw_devices] 0]
    refresh_hw_device -update_hw_probes false [lindex [get_hw_devices] 0]
    set_property PROGRAM.FILE $bitfile.bit [lindex [get_hw_devices] 0]

    program_hw_devices [lindex [get_hw_devices] 0]
    disconnect_hw_server
}

proc program_flash {mcsfile} {

    open_hw_manager
    connect_hw_server
    open_hw_target
    current_hw_device [get_hw_devices]

    create_hw_cfgmem -hw_device [lindex [get_hw_devices] 0] [lindex [get_cfgmem_parts {s25fl132k-spi-x1_x2_x4}] 0]

    set_property PROGRAM.ADDRESS_RANGE  {use_file} [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices] 0]]
    set_property PROGRAM.FILES [list $mcsfile.mcs ] [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices] 0]]
    set_property PROGRAM.PRM_FILE {} [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices] 0]]
    set_property PROGRAM.UNUSED_PIN_TERMINATION {pull-none} [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices] 0]]
    set_property PROGRAM.BLANK_CHECK  0 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices] 0]]
    set_property PROGRAM.ERASE  1 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices] 0]]
    set_property PROGRAM.CFG_PROGRAM  1 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices] 0]]
    set_property PROGRAM.VERIFY  1 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices] 0]]
    set_property PROGRAM.CHECKSUM  0 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices] 0]]

    create_hw_bitstream -hw_device [lindex [get_hw_devices] 0] [get_property PROGRAM.HW_CFGMEM_BITFILE [ lindex [get_hw_devices] 0]]
    program_hw_devices [lindex [get_hw_devices] 0]
    refresh_hw_device [lindex [get_hw_devices] 0]
    program_hw_cfgmem -hw_cfgmem [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices] 0]]

    boot_hw_device  [lindex [get_hw_devices] 0]
    disconnect_hw_server
}
