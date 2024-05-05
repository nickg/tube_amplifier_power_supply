
set_3v3_io xclk             H11
set_3v3_io ada_clock        A13
set_3v3_io ada_cs           B14
set_3v3_io adb_clock        D14
set_3v3_io adb_cs           E13
set_3v3_io ada_data         C14
set_3v3_io adb_data         F13
set_3v3_io adb_mux\[0\]     B6
set_3v3_io adb_mux\[1\]     A5
set_3v3_io adb_mux\[2\]     B5
set_3v3_io ada_mux\[0\]     B13
set_3v3_io ada_mux\[1\]     A12
set_3v3_io ada_mux\[2\]     A10
set_3v3_io bypass_relay     H1
set_3v3_io uart_tx          D2
set_3v3_io uart_rx          E2
set_3v3_io llc_ad_cs        P2
set_3v3_io llc_ad_data      L2
set_3v3_io llc_ad_clock     J1
set_3v3_io dhb_ad_cs        M3
set_3v3_io dhb_ad_data      J2
set_3v3_io dhb_ad_clock     L1

set_3v3_io rgb_led1\[2\]  F14
set_3v3_io rgb_led1\[1\]  G14
set_3v3_io rgb_led1\[0\]  D13

set_3v3_io rgb_led2\[2\]  H14
set_3v3_io rgb_led2\[1\]  J12
set_3v3_io rgb_led2\[0\]  H13

set_3v3_io rgb_led3\[2\]  J13
set_3v3_io rgb_led3\[1\]  L14
set_3v3_io rgb_led3\[0\]  J14

# pfc gates
set_3v3_io ac1_switch          G1 
set_3v3_io ac2_switch          A4 

# dhb gates
set_3v3_io dhb_primary_high     P5 
set_3v3_io dhb_primary_low      P4 
set_3v3_io dhb_secondary_high   N1 
set_3v3_io dhb_secondary_low    M1 

# llc gates
set_3v3_io pri_high      P3 
set_3v3_io pri_low       N4 
set_3v3_io sync1         M2 
set_3v3_io sync2         L3 
