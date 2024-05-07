// Verilog netlist produced by program LSE :  version Diamond (64-bit) 3.11.2.446
// Netlist written on Sun Jan 26 23:21:58 2020
//
// Verilog Description of module multiplier_18x18
//

module multiplier_18x18 (Clock, ClkEn, Aclr, DataA, DataB, Result) /* synthesis NGD_DRC_MASK=1 */ ;   // c:/users/jari/mycodeprojects/tube_power_v5/lfe5u/ip_cores/multiplier_18x18/multiplier_18x18.vhd(12[8:24])
    input Clock;   // c:/users/jari/mycodeprojects/tube_power_v5/lfe5u/ip_cores/multiplier_18x18/multiplier_18x18.vhd(14[9:14])
    input ClkEn;   // c:/users/jari/mycodeprojects/tube_power_v5/lfe5u/ip_cores/multiplier_18x18/multiplier_18x18.vhd(15[9:14])
    input Aclr;   // c:/users/jari/mycodeprojects/tube_power_v5/lfe5u/ip_cores/multiplier_18x18/multiplier_18x18.vhd(16[9:13])
    input [17:0]DataA;   // c:/users/jari/mycodeprojects/tube_power_v5/lfe5u/ip_cores/multiplier_18x18/multiplier_18x18.vhd(17[9:14])
    input [17:0]DataB;   // c:/users/jari/mycodeprojects/tube_power_v5/lfe5u/ip_cores/multiplier_18x18/multiplier_18x18.vhd(18[9:14])
    output [35:0]Result;   // c:/users/jari/mycodeprojects/tube_power_v5/lfe5u/ip_cores/multiplier_18x18/multiplier_18x18.vhd(19[9:15])
    
    wire Clock /* synthesis is_clock=1, SET_AS_NETWORK=Clock */ ;   // c:/users/jari/mycodeprojects/tube_power_v5/lfe5u/ip_cores/multiplier_18x18/multiplier_18x18.vhd(14[9:14])
    
    wire multiplier_18x18_or1_0, multiplier_18x18_or1_1, multiplier_18x18_or1_2, 
        multiplier_18x18_or1_3, multiplier_18x18_or1_4, multiplier_18x18_or1_5, 
        multiplier_18x18_or1_6, multiplier_18x18_or1_7, multiplier_18x18_or1_8, 
        multiplier_18x18_or1_9, multiplier_18x18_or1_10, multiplier_18x18_or1_11, 
        multiplier_18x18_or1_12, multiplier_18x18_or1_13, multiplier_18x18_or1_14, 
        multiplier_18x18_or1_15, multiplier_18x18_or1_16, multiplier_18x18_or1_17, 
        multiplier_18x18_or1_18, multiplier_18x18_or1_19, multiplier_18x18_or1_20, 
        multiplier_18x18_or1_21, multiplier_18x18_or1_22, multiplier_18x18_or1_23, 
        multiplier_18x18_or1_24, multiplier_18x18_or1_25, multiplier_18x18_or1_26, 
        multiplier_18x18_or1_27, multiplier_18x18_or1_28, multiplier_18x18_or1_29, 
        multiplier_18x18_or1_30, multiplier_18x18_or1_31, multiplier_18x18_or1_32, 
        multiplier_18x18_or1_33, multiplier_18x18_or1_34, multiplier_18x18_or1_35, 
        scuba_vhi, scuba_vlo;
    
    FD1P3DX FF_34 (.D(multiplier_18x18_or1_1), .SP(ClkEn), .CK(Clock), 
            .CD(Aclr), .Q(Result[1])) /* synthesis syn_black_box=true, GSR="ENABLED", syn_instantiated=1 */ ;   // c:/users/jari/mycodeprojects/tube_power_v5/lfe5u/ip_cores/multiplier_18x18/multiplier_18x18.vhd(147[12:19])
    defparam FF_34.GSR = "ENABLED";
    FD1P3DX FF_33 (.D(multiplier_18x18_or1_2), .SP(ClkEn), .CK(Clock), 
            .CD(Aclr), .Q(Result[2])) /* synthesis syn_black_box=true, GSR="ENABLED", syn_instantiated=1 */ ;   // c:/users/jari/mycodeprojects/tube_power_v5/lfe5u/ip_cores/multiplier_18x18/multiplier_18x18.vhd(151[12:19])
    defparam FF_33.GSR = "ENABLED";
    FD1P3DX FF_32 (.D(multiplier_18x18_or1_3), .SP(ClkEn), .CK(Clock), 
            .CD(Aclr), .Q(Result[3])) /* synthesis syn_black_box=true, GSR="ENABLED", syn_instantiated=1 */ ;   // c:/users/jari/mycodeprojects/tube_power_v5/lfe5u/ip_cores/multiplier_18x18/multiplier_18x18.vhd(155[12:19])
    defparam FF_32.GSR = "ENABLED";
    FD1P3DX FF_31 (.D(multiplier_18x18_or1_4), .SP(ClkEn), .CK(Clock), 
            .CD(Aclr), .Q(Result[4])) /* synthesis syn_black_box=true, GSR="ENABLED", syn_instantiated=1 */ ;   // c:/users/jari/mycodeprojects/tube_power_v5/lfe5u/ip_cores/multiplier_18x18/multiplier_18x18.vhd(159[12:19])
    defparam FF_31.GSR = "ENABLED";
    FD1P3DX FF_30 (.D(multiplier_18x18_or1_5), .SP(ClkEn), .CK(Clock), 
            .CD(Aclr), .Q(Result[5])) /* synthesis syn_black_box=true, GSR="ENABLED", syn_instantiated=1 */ ;   // c:/users/jari/mycodeprojects/tube_power_v5/lfe5u/ip_cores/multiplier_18x18/multiplier_18x18.vhd(163[12:19])
    defparam FF_30.GSR = "ENABLED";
    FD1P3DX FF_29 (.D(multiplier_18x18_or1_6), .SP(ClkEn), .CK(Clock), 
            .CD(Aclr), .Q(Result[6])) /* synthesis syn_black_box=true, GSR="ENABLED", syn_instantiated=1 */ ;   // c:/users/jari/mycodeprojects/tube_power_v5/lfe5u/ip_cores/multiplier_18x18/multiplier_18x18.vhd(167[12:19])
    defparam FF_29.GSR = "ENABLED";
    FD1P3DX FF_28 (.D(multiplier_18x18_or1_7), .SP(ClkEn), .CK(Clock), 
            .CD(Aclr), .Q(Result[7])) /* synthesis syn_black_box=true, GSR="ENABLED", syn_instantiated=1 */ ;   // c:/users/jari/mycodeprojects/tube_power_v5/lfe5u/ip_cores/multiplier_18x18/multiplier_18x18.vhd(171[12:19])
    defparam FF_28.GSR = "ENABLED";
    FD1P3DX FF_27 (.D(multiplier_18x18_or1_8), .SP(ClkEn), .CK(Clock), 
            .CD(Aclr), .Q(Result[8])) /* synthesis syn_black_box=true, GSR="ENABLED", syn_instantiated=1 */ ;   // c:/users/jari/mycodeprojects/tube_power_v5/lfe5u/ip_cores/multiplier_18x18/multiplier_18x18.vhd(175[12:19])
    defparam FF_27.GSR = "ENABLED";
    FD1P3DX FF_26 (.D(multiplier_18x18_or1_9), .SP(ClkEn), .CK(Clock), 
            .CD(Aclr), .Q(Result[9])) /* synthesis syn_black_box=true, GSR="ENABLED", syn_instantiated=1 */ ;   // c:/users/jari/mycodeprojects/tube_power_v5/lfe5u/ip_cores/multiplier_18x18/multiplier_18x18.vhd(179[12:19])
    defparam FF_26.GSR = "ENABLED";
    FD1P3DX FF_25 (.D(multiplier_18x18_or1_10), .SP(ClkEn), .CK(Clock), 
            .CD(Aclr), .Q(Result[10])) /* synthesis syn_black_box=true, GSR="ENABLED", syn_instantiated=1 */ ;   // c:/users/jari/mycodeprojects/tube_power_v5/lfe5u/ip_cores/multiplier_18x18/multiplier_18x18.vhd(183[12:19])
    defparam FF_25.GSR = "ENABLED";
    FD1P3DX FF_24 (.D(multiplier_18x18_or1_11), .SP(ClkEn), .CK(Clock), 
            .CD(Aclr), .Q(Result[11])) /* synthesis syn_black_box=true, GSR="ENABLED", syn_instantiated=1 */ ;   // c:/users/jari/mycodeprojects/tube_power_v5/lfe5u/ip_cores/multiplier_18x18/multiplier_18x18.vhd(187[12:19])
    defparam FF_24.GSR = "ENABLED";
    FD1P3DX FF_23 (.D(multiplier_18x18_or1_12), .SP(ClkEn), .CK(Clock), 
            .CD(Aclr), .Q(Result[12])) /* synthesis syn_black_box=true, GSR="ENABLED", syn_instantiated=1 */ ;   // c:/users/jari/mycodeprojects/tube_power_v5/lfe5u/ip_cores/multiplier_18x18/multiplier_18x18.vhd(191[12:19])
    defparam FF_23.GSR = "ENABLED";
    FD1P3DX FF_22 (.D(multiplier_18x18_or1_13), .SP(ClkEn), .CK(Clock), 
            .CD(Aclr), .Q(Result[13])) /* synthesis syn_black_box=true, GSR="ENABLED", syn_instantiated=1 */ ;   // c:/users/jari/mycodeprojects/tube_power_v5/lfe5u/ip_cores/multiplier_18x18/multiplier_18x18.vhd(195[12:19])
    defparam FF_22.GSR = "ENABLED";
    FD1P3DX FF_21 (.D(multiplier_18x18_or1_14), .SP(ClkEn), .CK(Clock), 
            .CD(Aclr), .Q(Result[14])) /* synthesis syn_black_box=true, GSR="ENABLED", syn_instantiated=1 */ ;   // c:/users/jari/mycodeprojects/tube_power_v5/lfe5u/ip_cores/multiplier_18x18/multiplier_18x18.vhd(199[12:19])
    defparam FF_21.GSR = "ENABLED";
    FD1P3DX FF_20 (.D(multiplier_18x18_or1_15), .SP(ClkEn), .CK(Clock), 
            .CD(Aclr), .Q(Result[15])) /* synthesis syn_black_box=true, GSR="ENABLED", syn_instantiated=1 */ ;   // c:/users/jari/mycodeprojects/tube_power_v5/lfe5u/ip_cores/multiplier_18x18/multiplier_18x18.vhd(203[12:19])
    defparam FF_20.GSR = "ENABLED";
    FD1P3DX FF_19 (.D(multiplier_18x18_or1_16), .SP(ClkEn), .CK(Clock), 
            .CD(Aclr), .Q(Result[16])) /* synthesis syn_black_box=true, GSR="ENABLED", syn_instantiated=1 */ ;   // c:/users/jari/mycodeprojects/tube_power_v5/lfe5u/ip_cores/multiplier_18x18/multiplier_18x18.vhd(207[12:19])
    defparam FF_19.GSR = "ENABLED";
    FD1P3DX FF_18 (.D(multiplier_18x18_or1_17), .SP(ClkEn), .CK(Clock), 
            .CD(Aclr), .Q(Result[17])) /* synthesis syn_black_box=true, GSR="ENABLED", syn_instantiated=1 */ ;   // c:/users/jari/mycodeprojects/tube_power_v5/lfe5u/ip_cores/multiplier_18x18/multiplier_18x18.vhd(211[12:19])
    defparam FF_18.GSR = "ENABLED";
    FD1P3DX FF_17 (.D(multiplier_18x18_or1_18), .SP(ClkEn), .CK(Clock), 
            .CD(Aclr), .Q(Result[18])) /* synthesis syn_black_box=true, GSR="ENABLED", syn_instantiated=1 */ ;   // c:/users/jari/mycodeprojects/tube_power_v5/lfe5u/ip_cores/multiplier_18x18/multiplier_18x18.vhd(215[12:19])
    defparam FF_17.GSR = "ENABLED";
    FD1P3DX FF_16 (.D(multiplier_18x18_or1_19), .SP(ClkEn), .CK(Clock), 
            .CD(Aclr), .Q(Result[19])) /* synthesis syn_black_box=true, GSR="ENABLED", syn_instantiated=1 */ ;   // c:/users/jari/mycodeprojects/tube_power_v5/lfe5u/ip_cores/multiplier_18x18/multiplier_18x18.vhd(219[12:19])
    defparam FF_16.GSR = "ENABLED";
    FD1P3DX FF_15 (.D(multiplier_18x18_or1_20), .SP(ClkEn), .CK(Clock), 
            .CD(Aclr), .Q(Result[20])) /* synthesis syn_black_box=true, GSR="ENABLED", syn_instantiated=1 */ ;   // c:/users/jari/mycodeprojects/tube_power_v5/lfe5u/ip_cores/multiplier_18x18/multiplier_18x18.vhd(223[12:19])
    defparam FF_15.GSR = "ENABLED";
    FD1P3DX FF_14 (.D(multiplier_18x18_or1_21), .SP(ClkEn), .CK(Clock), 
            .CD(Aclr), .Q(Result[21])) /* synthesis syn_black_box=true, GSR="ENABLED", syn_instantiated=1 */ ;   // c:/users/jari/mycodeprojects/tube_power_v5/lfe5u/ip_cores/multiplier_18x18/multiplier_18x18.vhd(227[12:19])
    defparam FF_14.GSR = "ENABLED";
    FD1P3DX FF_13 (.D(multiplier_18x18_or1_22), .SP(ClkEn), .CK(Clock), 
            .CD(Aclr), .Q(Result[22])) /* synthesis syn_black_box=true, GSR="ENABLED", syn_instantiated=1 */ ;   // c:/users/jari/mycodeprojects/tube_power_v5/lfe5u/ip_cores/multiplier_18x18/multiplier_18x18.vhd(231[12:19])
    defparam FF_13.GSR = "ENABLED";
    FD1P3DX FF_12 (.D(multiplier_18x18_or1_23), .SP(ClkEn), .CK(Clock), 
            .CD(Aclr), .Q(Result[23])) /* synthesis syn_black_box=true, GSR="ENABLED", syn_instantiated=1 */ ;   // c:/users/jari/mycodeprojects/tube_power_v5/lfe5u/ip_cores/multiplier_18x18/multiplier_18x18.vhd(235[12:19])
    defparam FF_12.GSR = "ENABLED";
    FD1P3DX FF_11 (.D(multiplier_18x18_or1_24), .SP(ClkEn), .CK(Clock), 
            .CD(Aclr), .Q(Result[24])) /* synthesis syn_black_box=true, GSR="ENABLED", syn_instantiated=1 */ ;   // c:/users/jari/mycodeprojects/tube_power_v5/lfe5u/ip_cores/multiplier_18x18/multiplier_18x18.vhd(239[12:19])
    defparam FF_11.GSR = "ENABLED";
    FD1P3DX FF_10 (.D(multiplier_18x18_or1_25), .SP(ClkEn), .CK(Clock), 
            .CD(Aclr), .Q(Result[25])) /* synthesis syn_black_box=true, GSR="ENABLED", syn_instantiated=1 */ ;   // c:/users/jari/mycodeprojects/tube_power_v5/lfe5u/ip_cores/multiplier_18x18/multiplier_18x18.vhd(243[12:19])
    defparam FF_10.GSR = "ENABLED";
    FD1P3DX FF_9 (.D(multiplier_18x18_or1_26), .SP(ClkEn), .CK(Clock), 
            .CD(Aclr), .Q(Result[26])) /* synthesis syn_black_box=true, GSR="ENABLED", syn_instantiated=1 */ ;   // c:/users/jari/mycodeprojects/tube_power_v5/lfe5u/ip_cores/multiplier_18x18/multiplier_18x18.vhd(247[11:18])
    defparam FF_9.GSR = "ENABLED";
    FD1P3DX FF_8 (.D(multiplier_18x18_or1_27), .SP(ClkEn), .CK(Clock), 
            .CD(Aclr), .Q(Result[27])) /* synthesis syn_black_box=true, GSR="ENABLED", syn_instantiated=1 */ ;   // c:/users/jari/mycodeprojects/tube_power_v5/lfe5u/ip_cores/multiplier_18x18/multiplier_18x18.vhd(251[11:18])
    defparam FF_8.GSR = "ENABLED";
    FD1P3DX FF_7 (.D(multiplier_18x18_or1_28), .SP(ClkEn), .CK(Clock), 
            .CD(Aclr), .Q(Result[28])) /* synthesis syn_black_box=true, GSR="ENABLED", syn_instantiated=1 */ ;   // c:/users/jari/mycodeprojects/tube_power_v5/lfe5u/ip_cores/multiplier_18x18/multiplier_18x18.vhd(255[11:18])
    defparam FF_7.GSR = "ENABLED";
    FD1P3DX FF_6 (.D(multiplier_18x18_or1_29), .SP(ClkEn), .CK(Clock), 
            .CD(Aclr), .Q(Result[29])) /* synthesis syn_black_box=true, GSR="ENABLED", syn_instantiated=1 */ ;   // c:/users/jari/mycodeprojects/tube_power_v5/lfe5u/ip_cores/multiplier_18x18/multiplier_18x18.vhd(259[11:18])
    defparam FF_6.GSR = "ENABLED";
    FD1P3DX FF_5 (.D(multiplier_18x18_or1_30), .SP(ClkEn), .CK(Clock), 
            .CD(Aclr), .Q(Result[30])) /* synthesis syn_black_box=true, GSR="ENABLED", syn_instantiated=1 */ ;   // c:/users/jari/mycodeprojects/tube_power_v5/lfe5u/ip_cores/multiplier_18x18/multiplier_18x18.vhd(263[11:18])
    defparam FF_5.GSR = "ENABLED";
    FD1P3DX FF_4 (.D(multiplier_18x18_or1_31), .SP(ClkEn), .CK(Clock), 
            .CD(Aclr), .Q(Result[31])) /* synthesis syn_black_box=true, GSR="ENABLED", syn_instantiated=1 */ ;   // c:/users/jari/mycodeprojects/tube_power_v5/lfe5u/ip_cores/multiplier_18x18/multiplier_18x18.vhd(267[11:18])
    defparam FF_4.GSR = "ENABLED";
    FD1P3DX FF_3 (.D(multiplier_18x18_or1_32), .SP(ClkEn), .CK(Clock), 
            .CD(Aclr), .Q(Result[32])) /* synthesis syn_black_box=true, GSR="ENABLED", syn_instantiated=1 */ ;   // c:/users/jari/mycodeprojects/tube_power_v5/lfe5u/ip_cores/multiplier_18x18/multiplier_18x18.vhd(271[11:18])
    defparam FF_3.GSR = "ENABLED";
    FD1P3DX FF_2 (.D(multiplier_18x18_or1_33), .SP(ClkEn), .CK(Clock), 
            .CD(Aclr), .Q(Result[33])) /* synthesis syn_black_box=true, GSR="ENABLED", syn_instantiated=1 */ ;   // c:/users/jari/mycodeprojects/tube_power_v5/lfe5u/ip_cores/multiplier_18x18/multiplier_18x18.vhd(275[11:18])
    defparam FF_2.GSR = "ENABLED";
    FD1P3DX FF_1 (.D(multiplier_18x18_or1_34), .SP(ClkEn), .CK(Clock), 
            .CD(Aclr), .Q(Result[34])) /* synthesis syn_black_box=true, GSR="ENABLED", syn_instantiated=1 */ ;   // c:/users/jari/mycodeprojects/tube_power_v5/lfe5u/ip_cores/multiplier_18x18/multiplier_18x18.vhd(279[11:18])
    defparam FF_1.GSR = "ENABLED";
    FD1P3DX FF_0 (.D(multiplier_18x18_or1_35), .SP(ClkEn), .CK(Clock), 
            .CD(Aclr), .Q(Result[35])) /* synthesis syn_black_box=true, GSR="ENABLED", syn_instantiated=1 */ ;   // c:/users/jari/mycodeprojects/tube_power_v5/lfe5u/ip_cores/multiplier_18x18/multiplier_18x18.vhd(283[11:18])
    defparam FF_0.GSR = "ENABLED";
    VHI scuba_vhi_inst (.Z(scuba_vhi));
    VLO scuba_vlo_inst (.Z(scuba_vlo));
    MULT18X18D dsp_mult_0 (.A17(DataA[17]), .A16(DataA[16]), .A15(DataA[15]), 
            .A14(DataA[14]), .A13(DataA[13]), .A12(DataA[12]), .A11(DataA[11]), 
            .A10(DataA[10]), .A9(DataA[9]), .A8(DataA[8]), .A7(DataA[7]), 
            .A6(DataA[6]), .A5(DataA[5]), .A4(DataA[4]), .A3(DataA[3]), 
            .A2(DataA[2]), .A1(DataA[1]), .A0(DataA[0]), .B17(DataB[17]), 
            .B16(DataB[16]), .B15(DataB[15]), .B14(DataB[14]), .B13(DataB[13]), 
            .B12(DataB[12]), .B11(DataB[11]), .B10(DataB[10]), .B9(DataB[9]), 
            .B8(DataB[8]), .B7(DataB[7]), .B6(DataB[6]), .B5(DataB[5]), 
            .B4(DataB[4]), .B3(DataB[3]), .B2(DataB[2]), .B1(DataB[1]), 
            .B0(DataB[0]), .C17(scuba_vlo), .C16(scuba_vlo), .C15(scuba_vlo), 
            .C14(scuba_vlo), .C13(scuba_vlo), .C12(scuba_vlo), .C11(scuba_vlo), 
            .C10(scuba_vlo), .C9(scuba_vlo), .C8(scuba_vlo), .C7(scuba_vlo), 
            .C6(scuba_vlo), .C5(scuba_vlo), .C4(scuba_vlo), .C3(scuba_vlo), 
            .C2(scuba_vlo), .C1(scuba_vlo), .C0(scuba_vlo), .SIGNEDA(scuba_vhi), 
            .SIGNEDB(scuba_vhi), .SOURCEA(scuba_vlo), .SOURCEB(scuba_vlo), 
            .CLK3(scuba_vlo), .CLK2(scuba_vlo), .CLK1(scuba_vlo), .CLK0(Clock), 
            .CE3(scuba_vhi), .CE2(scuba_vhi), .CE1(scuba_vhi), .CE0(ClkEn), 
            .RST3(scuba_vlo), .RST2(scuba_vlo), .RST1(scuba_vlo), .RST0(Aclr), 
            .SRIA17(scuba_vlo), .SRIA16(scuba_vlo), .SRIA15(scuba_vlo), 
            .SRIA14(scuba_vlo), .SRIA13(scuba_vlo), .SRIA12(scuba_vlo), 
            .SRIA11(scuba_vlo), .SRIA10(scuba_vlo), .SRIA9(scuba_vlo), 
            .SRIA8(scuba_vlo), .SRIA7(scuba_vlo), .SRIA6(scuba_vlo), .SRIA5(scuba_vlo), 
            .SRIA4(scuba_vlo), .SRIA3(scuba_vlo), .SRIA2(scuba_vlo), .SRIA1(scuba_vlo), 
            .SRIA0(scuba_vlo), .SRIB17(scuba_vlo), .SRIB16(scuba_vlo), 
            .SRIB15(scuba_vlo), .SRIB14(scuba_vlo), .SRIB13(scuba_vlo), 
            .SRIB12(scuba_vlo), .SRIB11(scuba_vlo), .SRIB10(scuba_vlo), 
            .SRIB9(scuba_vlo), .SRIB8(scuba_vlo), .SRIB7(scuba_vlo), .SRIB6(scuba_vlo), 
            .SRIB5(scuba_vlo), .SRIB4(scuba_vlo), .SRIB3(scuba_vlo), .SRIB2(scuba_vlo), 
            .SRIB1(scuba_vlo), .SRIB0(scuba_vlo), .P35(multiplier_18x18_or1_35), 
            .P34(multiplier_18x18_or1_34), .P33(multiplier_18x18_or1_33), 
            .P32(multiplier_18x18_or1_32), .P31(multiplier_18x18_or1_31), 
            .P30(multiplier_18x18_or1_30), .P29(multiplier_18x18_or1_29), 
            .P28(multiplier_18x18_or1_28), .P27(multiplier_18x18_or1_27), 
            .P26(multiplier_18x18_or1_26), .P25(multiplier_18x18_or1_25), 
            .P24(multiplier_18x18_or1_24), .P23(multiplier_18x18_or1_23), 
            .P22(multiplier_18x18_or1_22), .P21(multiplier_18x18_or1_21), 
            .P20(multiplier_18x18_or1_20), .P19(multiplier_18x18_or1_19), 
            .P18(multiplier_18x18_or1_18), .P17(multiplier_18x18_or1_17), 
            .P16(multiplier_18x18_or1_16), .P15(multiplier_18x18_or1_15), 
            .P14(multiplier_18x18_or1_14), .P13(multiplier_18x18_or1_13), 
            .P12(multiplier_18x18_or1_12), .P11(multiplier_18x18_or1_11), 
            .P10(multiplier_18x18_or1_10), .P9(multiplier_18x18_or1_9), 
            .P8(multiplier_18x18_or1_8), .P7(multiplier_18x18_or1_7), .P6(multiplier_18x18_or1_6), 
            .P5(multiplier_18x18_or1_5), .P4(multiplier_18x18_or1_4), .P3(multiplier_18x18_or1_3), 
            .P2(multiplier_18x18_or1_2), .P1(multiplier_18x18_or1_1), .P0(multiplier_18x18_or1_0)) /* synthesis syn_black_box=true, syn_instantiated=1 */ ;   // c:/users/jari/mycodeprojects/tube_power_v5/lfe5u/ip_cores/multiplier_18x18/multiplier_18x18.vhd(293[17:27])
    defparam dsp_mult_0.REG_INPUTA_CLK = "CLK0";
    defparam dsp_mult_0.REG_INPUTA_CE = "CE0";
    defparam dsp_mult_0.REG_INPUTA_RST = "RST0";
    defparam dsp_mult_0.REG_INPUTB_CLK = "CLK0";
    defparam dsp_mult_0.REG_INPUTB_CE = "CE0";
    defparam dsp_mult_0.REG_INPUTB_RST = "RST0";
    defparam dsp_mult_0.REG_INPUTC_CLK = "NONE";
    defparam dsp_mult_0.REG_INPUTC_CE = "CE0";
    defparam dsp_mult_0.REG_INPUTC_RST = "RST0";
    defparam dsp_mult_0.REG_PIPELINE_CLK = "CLK0";
    defparam dsp_mult_0.REG_PIPELINE_CE = "CE0";
    defparam dsp_mult_0.REG_PIPELINE_RST = "RST0";
    defparam dsp_mult_0.REG_OUTPUT_CLK = "CLK0";
    defparam dsp_mult_0.REG_OUTPUT_CE = "CE0";
    defparam dsp_mult_0.REG_OUTPUT_RST = "RST0";
    defparam dsp_mult_0.CLK0_DIV = "ENABLED";
    defparam dsp_mult_0.CLK1_DIV = "ENABLED";
    defparam dsp_mult_0.CLK2_DIV = "ENABLED";
    defparam dsp_mult_0.CLK3_DIV = "ENABLED";
    defparam dsp_mult_0.HIGHSPEED_CLK = "NONE";
    defparam dsp_mult_0.GSR = "ENABLED";
    defparam dsp_mult_0.CAS_MATCH_REG = "FALSE";
    defparam dsp_mult_0.SOURCEB_MODE = "B_SHIFT";
    defparam dsp_mult_0.MULT_BYPASS = "DISABLED";
    defparam dsp_mult_0.RESETMODE = "ASYNC";
    GSR GSR_INST (.GSR(scuba_vhi));
    FD1P3DX FF_35 (.D(multiplier_18x18_or1_0), .SP(ClkEn), .CK(Clock), 
            .CD(Aclr), .Q(Result[0])) /* synthesis syn_black_box=true, GSR="ENABLED", syn_instantiated=1 */ ;   // c:/users/jari/mycodeprojects/tube_power_v5/lfe5u/ip_cores/multiplier_18x18/multiplier_18x18.vhd(143[12:19])
    defparam FF_35.GSR = "ENABLED";
    PUR PUR_INST (.PUR(scuba_vhi));
    defparam PUR_INST.RST_PULSE = 1;
    
endmodule
//
// Verilog Description of module PUR
// module not written out since it is a black-box. 
//

