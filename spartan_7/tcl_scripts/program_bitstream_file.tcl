proc program_ram {bitfile} {
    open_hw_manager
    connect_hw_server
    open_hw_target

    # Program and Refresh the Device

    current_hw_device [lindex [get_hw_devices] 0]
    refresh_hw_device -update_hw_probes false [lindex [get_hw_devices] 0]
    set_property PROGRAM.FILE $bitfile [lindex [get_hw_devices] 0]

    program_hw_devices [lindex [get_hw_devices] 0]
    disconnect_hw_server
}
