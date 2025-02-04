-- VHDL netlist generated by SCUBA Diamond (64-bit) 3.11.2.446
-- Module  Version: 4.9
--C:\Programs\diamond\diamond\3.11_x64\ispfpga\bin\nt64\scuba.exe -w -n multiplier_18x18 -lang vhdl -synth lse -bus_exp 7 -bb -arch sa5p00 -type dspmult -simple_portname -widtha 18 -widthb 18 -widthp 36 -signed -PL_stages 2 -input_reg -output_reg -clk0 -ce0 -rst0 -fdc C:/Users/Jari/mycodeprojects/tube_power_v5/lfe5u/ip_cores/multiplier_18x18/multiplier_18x18.fdc 

-- Sun Jan 26 23:21:57 2020

library IEEE;
use IEEE.std_logic_1164.all;
library ECP5U;
use ECP5U.components.all;

entity multiplier_18x18 is
    port (
        Clock: in  std_logic; 
        ClkEn: in  std_logic; 
        Aclr: in  std_logic; 
        DataA: in  std_logic_vector(17 downto 0); 
        DataB: in  std_logic_vector(17 downto 0); 
        Result: out  std_logic_vector(35 downto 0));
end multiplier_18x18;

architecture Structure of multiplier_18x18 is

    -- internal signal declarations
    signal multiplier_18x18_or1_0: std_logic;
    signal multiplier_18x18_or1_1: std_logic;
    signal multiplier_18x18_or1_2: std_logic;
    signal multiplier_18x18_or1_3: std_logic;
    signal multiplier_18x18_or1_4: std_logic;
    signal multiplier_18x18_or1_5: std_logic;
    signal multiplier_18x18_or1_6: std_logic;
    signal multiplier_18x18_or1_7: std_logic;
    signal multiplier_18x18_or1_8: std_logic;
    signal multiplier_18x18_or1_9: std_logic;
    signal multiplier_18x18_or1_10: std_logic;
    signal multiplier_18x18_or1_11: std_logic;
    signal multiplier_18x18_or1_12: std_logic;
    signal multiplier_18x18_or1_13: std_logic;
    signal multiplier_18x18_or1_14: std_logic;
    signal multiplier_18x18_or1_15: std_logic;
    signal multiplier_18x18_or1_16: std_logic;
    signal multiplier_18x18_or1_17: std_logic;
    signal multiplier_18x18_or1_18: std_logic;
    signal multiplier_18x18_or1_19: std_logic;
    signal multiplier_18x18_or1_20: std_logic;
    signal multiplier_18x18_or1_21: std_logic;
    signal multiplier_18x18_or1_22: std_logic;
    signal multiplier_18x18_or1_23: std_logic;
    signal multiplier_18x18_or1_24: std_logic;
    signal multiplier_18x18_or1_25: std_logic;
    signal multiplier_18x18_or1_26: std_logic;
    signal multiplier_18x18_or1_27: std_logic;
    signal multiplier_18x18_or1_28: std_logic;
    signal multiplier_18x18_or1_29: std_logic;
    signal multiplier_18x18_or1_30: std_logic;
    signal multiplier_18x18_or1_31: std_logic;
    signal multiplier_18x18_or1_32: std_logic;
    signal multiplier_18x18_or1_33: std_logic;
    signal multiplier_18x18_or1_34: std_logic;
    signal multiplier_18x18_or1_35: std_logic;
    signal multiplier_18x18_mult_direct_out_1_35: std_logic;
    signal multiplier_18x18_mult_direct_out_1_34: std_logic;
    signal multiplier_18x18_mult_direct_out_1_33: std_logic;
    signal multiplier_18x18_mult_direct_out_1_32: std_logic;
    signal multiplier_18x18_mult_direct_out_1_31: std_logic;
    signal multiplier_18x18_mult_direct_out_1_30: std_logic;
    signal multiplier_18x18_mult_direct_out_1_29: std_logic;
    signal multiplier_18x18_mult_direct_out_1_28: std_logic;
    signal multiplier_18x18_mult_direct_out_1_27: std_logic;
    signal multiplier_18x18_mult_direct_out_1_26: std_logic;
    signal multiplier_18x18_mult_direct_out_1_25: std_logic;
    signal multiplier_18x18_mult_direct_out_1_24: std_logic;
    signal multiplier_18x18_mult_direct_out_1_23: std_logic;
    signal multiplier_18x18_mult_direct_out_1_22: std_logic;
    signal multiplier_18x18_mult_direct_out_1_21: std_logic;
    signal multiplier_18x18_mult_direct_out_1_20: std_logic;
    signal multiplier_18x18_mult_direct_out_1_19: std_logic;
    signal multiplier_18x18_mult_direct_out_1_18: std_logic;
    signal multiplier_18x18_mult_direct_out_1_17: std_logic;
    signal multiplier_18x18_mult_direct_out_1_16: std_logic;
    signal multiplier_18x18_mult_direct_out_1_15: std_logic;
    signal multiplier_18x18_mult_direct_out_1_14: std_logic;
    signal multiplier_18x18_mult_direct_out_1_13: std_logic;
    signal multiplier_18x18_mult_direct_out_1_12: std_logic;
    signal multiplier_18x18_mult_direct_out_1_11: std_logic;
    signal multiplier_18x18_mult_direct_out_1_10: std_logic;
    signal multiplier_18x18_mult_direct_out_1_9: std_logic;
    signal multiplier_18x18_mult_direct_out_1_8: std_logic;
    signal multiplier_18x18_mult_direct_out_1_7: std_logic;
    signal multiplier_18x18_mult_direct_out_1_6: std_logic;
    signal multiplier_18x18_mult_direct_out_1_5: std_logic;
    signal multiplier_18x18_mult_direct_out_1_4: std_logic;
    signal multiplier_18x18_mult_direct_out_1_3: std_logic;
    signal multiplier_18x18_mult_direct_out_1_2: std_logic;
    signal multiplier_18x18_mult_direct_out_1_1: std_logic;
    signal multiplier_18x18_mult_direct_out_1_0: std_logic;
    signal scuba_vhi: std_logic;
    signal scuba_vlo: std_logic;

    attribute GSR : string; 
    attribute GSR of FF_35 : label is "ENABLED";
    attribute GSR of FF_34 : label is "ENABLED";
    attribute GSR of FF_33 : label is "ENABLED";
    attribute GSR of FF_32 : label is "ENABLED";
    attribute GSR of FF_31 : label is "ENABLED";
    attribute GSR of FF_30 : label is "ENABLED";
    attribute GSR of FF_29 : label is "ENABLED";
    attribute GSR of FF_28 : label is "ENABLED";
    attribute GSR of FF_27 : label is "ENABLED";
    attribute GSR of FF_26 : label is "ENABLED";
    attribute GSR of FF_25 : label is "ENABLED";
    attribute GSR of FF_24 : label is "ENABLED";
    attribute GSR of FF_23 : label is "ENABLED";
    attribute GSR of FF_22 : label is "ENABLED";
    attribute GSR of FF_21 : label is "ENABLED";
    attribute GSR of FF_20 : label is "ENABLED";
    attribute GSR of FF_19 : label is "ENABLED";
    attribute GSR of FF_18 : label is "ENABLED";
    attribute GSR of FF_17 : label is "ENABLED";
    attribute GSR of FF_16 : label is "ENABLED";
    attribute GSR of FF_15 : label is "ENABLED";
    attribute GSR of FF_14 : label is "ENABLED";
    attribute GSR of FF_13 : label is "ENABLED";
    attribute GSR of FF_12 : label is "ENABLED";
    attribute GSR of FF_11 : label is "ENABLED";
    attribute GSR of FF_10 : label is "ENABLED";
    attribute GSR of FF_9 : label is "ENABLED";
    attribute GSR of FF_8 : label is "ENABLED";
    attribute GSR of FF_7 : label is "ENABLED";
    attribute GSR of FF_6 : label is "ENABLED";
    attribute GSR of FF_5 : label is "ENABLED";
    attribute GSR of FF_4 : label is "ENABLED";
    attribute GSR of FF_3 : label is "ENABLED";
    attribute GSR of FF_2 : label is "ENABLED";
    attribute GSR of FF_1 : label is "ENABLED";
    attribute GSR of FF_0 : label is "ENABLED";
    attribute syn_keep : boolean;
    attribute NGD_DRC_MASK : integer;
    attribute NGD_DRC_MASK of Structure : architecture is 1;

begin
    -- component instantiation statements
    FF_35: FD1P3DX
        port map (D=>multiplier_18x18_or1_0, SP=>ClkEn, CK=>Clock, 
            CD=>Aclr, Q=>Result(0));

    FF_34: FD1P3DX
        port map (D=>multiplier_18x18_or1_1, SP=>ClkEn, CK=>Clock, 
            CD=>Aclr, Q=>Result(1));

    FF_33: FD1P3DX
        port map (D=>multiplier_18x18_or1_2, SP=>ClkEn, CK=>Clock, 
            CD=>Aclr, Q=>Result(2));

    FF_32: FD1P3DX
        port map (D=>multiplier_18x18_or1_3, SP=>ClkEn, CK=>Clock, 
            CD=>Aclr, Q=>Result(3));

    FF_31: FD1P3DX
        port map (D=>multiplier_18x18_or1_4, SP=>ClkEn, CK=>Clock, 
            CD=>Aclr, Q=>Result(4));

    FF_30: FD1P3DX
        port map (D=>multiplier_18x18_or1_5, SP=>ClkEn, CK=>Clock, 
            CD=>Aclr, Q=>Result(5));

    FF_29: FD1P3DX
        port map (D=>multiplier_18x18_or1_6, SP=>ClkEn, CK=>Clock, 
            CD=>Aclr, Q=>Result(6));

    FF_28: FD1P3DX
        port map (D=>multiplier_18x18_or1_7, SP=>ClkEn, CK=>Clock, 
            CD=>Aclr, Q=>Result(7));

    FF_27: FD1P3DX
        port map (D=>multiplier_18x18_or1_8, SP=>ClkEn, CK=>Clock, 
            CD=>Aclr, Q=>Result(8));

    FF_26: FD1P3DX
        port map (D=>multiplier_18x18_or1_9, SP=>ClkEn, CK=>Clock, 
            CD=>Aclr, Q=>Result(9));

    FF_25: FD1P3DX
        port map (D=>multiplier_18x18_or1_10, SP=>ClkEn, CK=>Clock, 
            CD=>Aclr, Q=>Result(10));

    FF_24: FD1P3DX
        port map (D=>multiplier_18x18_or1_11, SP=>ClkEn, CK=>Clock, 
            CD=>Aclr, Q=>Result(11));

    FF_23: FD1P3DX
        port map (D=>multiplier_18x18_or1_12, SP=>ClkEn, CK=>Clock, 
            CD=>Aclr, Q=>Result(12));

    FF_22: FD1P3DX
        port map (D=>multiplier_18x18_or1_13, SP=>ClkEn, CK=>Clock, 
            CD=>Aclr, Q=>Result(13));

    FF_21: FD1P3DX
        port map (D=>multiplier_18x18_or1_14, SP=>ClkEn, CK=>Clock, 
            CD=>Aclr, Q=>Result(14));

    FF_20: FD1P3DX
        port map (D=>multiplier_18x18_or1_15, SP=>ClkEn, CK=>Clock, 
            CD=>Aclr, Q=>Result(15));

    FF_19: FD1P3DX
        port map (D=>multiplier_18x18_or1_16, SP=>ClkEn, CK=>Clock, 
            CD=>Aclr, Q=>Result(16));

    FF_18: FD1P3DX
        port map (D=>multiplier_18x18_or1_17, SP=>ClkEn, CK=>Clock, 
            CD=>Aclr, Q=>Result(17));

    FF_17: FD1P3DX
        port map (D=>multiplier_18x18_or1_18, SP=>ClkEn, CK=>Clock, 
            CD=>Aclr, Q=>Result(18));

    FF_16: FD1P3DX
        port map (D=>multiplier_18x18_or1_19, SP=>ClkEn, CK=>Clock, 
            CD=>Aclr, Q=>Result(19));

    FF_15: FD1P3DX
        port map (D=>multiplier_18x18_or1_20, SP=>ClkEn, CK=>Clock, 
            CD=>Aclr, Q=>Result(20));

    FF_14: FD1P3DX
        port map (D=>multiplier_18x18_or1_21, SP=>ClkEn, CK=>Clock, 
            CD=>Aclr, Q=>Result(21));

    FF_13: FD1P3DX
        port map (D=>multiplier_18x18_or1_22, SP=>ClkEn, CK=>Clock, 
            CD=>Aclr, Q=>Result(22));

    FF_12: FD1P3DX
        port map (D=>multiplier_18x18_or1_23, SP=>ClkEn, CK=>Clock, 
            CD=>Aclr, Q=>Result(23));

    FF_11: FD1P3DX
        port map (D=>multiplier_18x18_or1_24, SP=>ClkEn, CK=>Clock, 
            CD=>Aclr, Q=>Result(24));

    FF_10: FD1P3DX
        port map (D=>multiplier_18x18_or1_25, SP=>ClkEn, CK=>Clock, 
            CD=>Aclr, Q=>Result(25));

    FF_9: FD1P3DX
        port map (D=>multiplier_18x18_or1_26, SP=>ClkEn, CK=>Clock, 
            CD=>Aclr, Q=>Result(26));

    FF_8: FD1P3DX
        port map (D=>multiplier_18x18_or1_27, SP=>ClkEn, CK=>Clock, 
            CD=>Aclr, Q=>Result(27));

    FF_7: FD1P3DX
        port map (D=>multiplier_18x18_or1_28, SP=>ClkEn, CK=>Clock, 
            CD=>Aclr, Q=>Result(28));

    FF_6: FD1P3DX
        port map (D=>multiplier_18x18_or1_29, SP=>ClkEn, CK=>Clock, 
            CD=>Aclr, Q=>Result(29));

    FF_5: FD1P3DX
        port map (D=>multiplier_18x18_or1_30, SP=>ClkEn, CK=>Clock, 
            CD=>Aclr, Q=>Result(30));

    FF_4: FD1P3DX
        port map (D=>multiplier_18x18_or1_31, SP=>ClkEn, CK=>Clock, 
            CD=>Aclr, Q=>Result(31));

    FF_3: FD1P3DX
        port map (D=>multiplier_18x18_or1_32, SP=>ClkEn, CK=>Clock, 
            CD=>Aclr, Q=>Result(32));

    FF_2: FD1P3DX
        port map (D=>multiplier_18x18_or1_33, SP=>ClkEn, CK=>Clock, 
            CD=>Aclr, Q=>Result(33));

    FF_1: FD1P3DX
        port map (D=>multiplier_18x18_or1_34, SP=>ClkEn, CK=>Clock, 
            CD=>Aclr, Q=>Result(34));

    FF_0: FD1P3DX
        port map (D=>multiplier_18x18_or1_35, SP=>ClkEn, CK=>Clock, 
            CD=>Aclr, Q=>Result(35));

    scuba_vhi_inst: VHI
        port map (Z=>scuba_vhi);

    scuba_vlo_inst: VLO
        port map (Z=>scuba_vlo);

    dsp_mult_0: MULT18X18D
        generic map (CLK3_DIV=> "ENABLED", CLK2_DIV=> "ENABLED", 
        CLK1_DIV=> "ENABLED", CLK0_DIV=> "ENABLED", HIGHSPEED_CLK=> "NONE", 
        REG_INPUTC_RST=> "RST0", REG_INPUTC_CE=> "CE0", REG_INPUTC_CLK=> "NONE", 
        SOURCEB_MODE=> "B_SHIFT", MULT_BYPASS=> "DISABLED", 
        CAS_MATCH_REG=> "FALSE", RESETMODE=> "ASYNC", GSR=> "ENABLED", 
        REG_OUTPUT_RST=> "RST0", REG_OUTPUT_CE=> "CE0", REG_OUTPUT_CLK=> "CLK0", 
        REG_PIPELINE_RST=> "RST0", REG_PIPELINE_CE=> "CE0", 
        REG_PIPELINE_CLK=> "CLK0", REG_INPUTB_RST=> "RST0", 
        REG_INPUTB_CE=> "CE0", REG_INPUTB_CLK=> "CLK0", REG_INPUTA_RST=> "RST0", 
        REG_INPUTA_CE=> "CE0", REG_INPUTA_CLK=> "CLK0")
        port map (A17=>DataA(17), A16=>DataA(16), A15=>DataA(15), 
            A14=>DataA(14), A13=>DataA(13), A12=>DataA(12), 
            A11=>DataA(11), A10=>DataA(10), A9=>DataA(9), A8=>DataA(8), 
            A7=>DataA(7), A6=>DataA(6), A5=>DataA(5), A4=>DataA(4), 
            A3=>DataA(3), A2=>DataA(2), A1=>DataA(1), A0=>DataA(0), 
            B17=>DataB(17), B16=>DataB(16), B15=>DataB(15), 
            B14=>DataB(14), B13=>DataB(13), B12=>DataB(12), 
            B11=>DataB(11), B10=>DataB(10), B9=>DataB(9), B8=>DataB(8), 
            B7=>DataB(7), B6=>DataB(6), B5=>DataB(5), B4=>DataB(4), 
            B3=>DataB(3), B2=>DataB(2), B1=>DataB(1), B0=>DataB(0), 
            C17=>scuba_vlo, C16=>scuba_vlo, C15=>scuba_vlo, 
            C14=>scuba_vlo, C13=>scuba_vlo, C12=>scuba_vlo, 
            C11=>scuba_vlo, C10=>scuba_vlo, C9=>scuba_vlo, C8=>scuba_vlo, 
            C7=>scuba_vlo, C6=>scuba_vlo, C5=>scuba_vlo, C4=>scuba_vlo, 
            C3=>scuba_vlo, C2=>scuba_vlo, C1=>scuba_vlo, C0=>scuba_vlo, 
            SIGNEDA=>scuba_vhi, SIGNEDB=>scuba_vhi, SOURCEA=>scuba_vlo, 
            SOURCEB=>scuba_vlo, CE0=>ClkEn, CE1=>scuba_vhi, 
            CE2=>scuba_vhi, CE3=>scuba_vhi, CLK0=>Clock, CLK1=>scuba_vlo, 
            CLK2=>scuba_vlo, CLK3=>scuba_vlo, RST0=>Aclr, 
            RST1=>scuba_vlo, RST2=>scuba_vlo, RST3=>scuba_vlo, 
            SRIA17=>scuba_vlo, SRIA16=>scuba_vlo, SRIA15=>scuba_vlo, 
            SRIA14=>scuba_vlo, SRIA13=>scuba_vlo, SRIA12=>scuba_vlo, 
            SRIA11=>scuba_vlo, SRIA10=>scuba_vlo, SRIA9=>scuba_vlo, 
            SRIA8=>scuba_vlo, SRIA7=>scuba_vlo, SRIA6=>scuba_vlo, 
            SRIA5=>scuba_vlo, SRIA4=>scuba_vlo, SRIA3=>scuba_vlo, 
            SRIA2=>scuba_vlo, SRIA1=>scuba_vlo, SRIA0=>scuba_vlo, 
            SRIB17=>scuba_vlo, SRIB16=>scuba_vlo, SRIB15=>scuba_vlo, 
            SRIB14=>scuba_vlo, SRIB13=>scuba_vlo, SRIB12=>scuba_vlo, 
            SRIB11=>scuba_vlo, SRIB10=>scuba_vlo, SRIB9=>scuba_vlo, 
            SRIB8=>scuba_vlo, SRIB7=>scuba_vlo, SRIB6=>scuba_vlo, 
            SRIB5=>scuba_vlo, SRIB4=>scuba_vlo, SRIB3=>scuba_vlo, 
            SRIB2=>scuba_vlo, SRIB1=>scuba_vlo, SRIB0=>scuba_vlo, 
            SROA17=>open, SROA16=>open, SROA15=>open, SROA14=>open, 
            SROA13=>open, SROA12=>open, SROA11=>open, SROA10=>open, 
            SROA9=>open, SROA8=>open, SROA7=>open, SROA6=>open, 
            SROA5=>open, SROA4=>open, SROA3=>open, SROA2=>open, 
            SROA1=>open, SROA0=>open, SROB17=>open, SROB16=>open, 
            SROB15=>open, SROB14=>open, SROB13=>open, SROB12=>open, 
            SROB11=>open, SROB10=>open, SROB9=>open, SROB8=>open, 
            SROB7=>open, SROB6=>open, SROB5=>open, SROB4=>open, 
            SROB3=>open, SROB2=>open, SROB1=>open, SROB0=>open, 
            ROA17=>open, ROA16=>open, ROA15=>open, ROA14=>open, 
            ROA13=>open, ROA12=>open, ROA11=>open, ROA10=>open, 
            ROA9=>open, ROA8=>open, ROA7=>open, ROA6=>open, ROA5=>open, 
            ROA4=>open, ROA3=>open, ROA2=>open, ROA1=>open, ROA0=>open, 
            ROB17=>open, ROB16=>open, ROB15=>open, ROB14=>open, 
            ROB13=>open, ROB12=>open, ROB11=>open, ROB10=>open, 
            ROB9=>open, ROB8=>open, ROB7=>open, ROB6=>open, ROB5=>open, 
            ROB4=>open, ROB3=>open, ROB2=>open, ROB1=>open, ROB0=>open, 
            ROC17=>open, ROC16=>open, ROC15=>open, ROC14=>open, 
            ROC13=>open, ROC12=>open, ROC11=>open, ROC10=>open, 
            ROC9=>open, ROC8=>open, ROC7=>open, ROC6=>open, ROC5=>open, 
            ROC4=>open, ROC3=>open, ROC2=>open, ROC1=>open, ROC0=>open, 
            P35=>multiplier_18x18_mult_direct_out_1_35, 
            P34=>multiplier_18x18_mult_direct_out_1_34, 
            P33=>multiplier_18x18_mult_direct_out_1_33, 
            P32=>multiplier_18x18_mult_direct_out_1_32, 
            P31=>multiplier_18x18_mult_direct_out_1_31, 
            P30=>multiplier_18x18_mult_direct_out_1_30, 
            P29=>multiplier_18x18_mult_direct_out_1_29, 
            P28=>multiplier_18x18_mult_direct_out_1_28, 
            P27=>multiplier_18x18_mult_direct_out_1_27, 
            P26=>multiplier_18x18_mult_direct_out_1_26, 
            P25=>multiplier_18x18_mult_direct_out_1_25, 
            P24=>multiplier_18x18_mult_direct_out_1_24, 
            P23=>multiplier_18x18_mult_direct_out_1_23, 
            P22=>multiplier_18x18_mult_direct_out_1_22, 
            P21=>multiplier_18x18_mult_direct_out_1_21, 
            P20=>multiplier_18x18_mult_direct_out_1_20, 
            P19=>multiplier_18x18_mult_direct_out_1_19, 
            P18=>multiplier_18x18_mult_direct_out_1_18, 
            P17=>multiplier_18x18_mult_direct_out_1_17, 
            P16=>multiplier_18x18_mult_direct_out_1_16, 
            P15=>multiplier_18x18_mult_direct_out_1_15, 
            P14=>multiplier_18x18_mult_direct_out_1_14, 
            P13=>multiplier_18x18_mult_direct_out_1_13, 
            P12=>multiplier_18x18_mult_direct_out_1_12, 
            P11=>multiplier_18x18_mult_direct_out_1_11, 
            P10=>multiplier_18x18_mult_direct_out_1_10, 
            P9=>multiplier_18x18_mult_direct_out_1_9, 
            P8=>multiplier_18x18_mult_direct_out_1_8, 
            P7=>multiplier_18x18_mult_direct_out_1_7, 
            P6=>multiplier_18x18_mult_direct_out_1_6, 
            P5=>multiplier_18x18_mult_direct_out_1_5, 
            P4=>multiplier_18x18_mult_direct_out_1_4, 
            P3=>multiplier_18x18_mult_direct_out_1_3, 
            P2=>multiplier_18x18_mult_direct_out_1_2, 
            P1=>multiplier_18x18_mult_direct_out_1_1, 
            P0=>multiplier_18x18_mult_direct_out_1_0, SIGNEDP=>open);

    multiplier_18x18_or1_35 <= multiplier_18x18_mult_direct_out_1_35;
    multiplier_18x18_or1_34 <= multiplier_18x18_mult_direct_out_1_34;
    multiplier_18x18_or1_33 <= multiplier_18x18_mult_direct_out_1_33;
    multiplier_18x18_or1_32 <= multiplier_18x18_mult_direct_out_1_32;
    multiplier_18x18_or1_31 <= multiplier_18x18_mult_direct_out_1_31;
    multiplier_18x18_or1_30 <= multiplier_18x18_mult_direct_out_1_30;
    multiplier_18x18_or1_29 <= multiplier_18x18_mult_direct_out_1_29;
    multiplier_18x18_or1_28 <= multiplier_18x18_mult_direct_out_1_28;
    multiplier_18x18_or1_27 <= multiplier_18x18_mult_direct_out_1_27;
    multiplier_18x18_or1_26 <= multiplier_18x18_mult_direct_out_1_26;
    multiplier_18x18_or1_25 <= multiplier_18x18_mult_direct_out_1_25;
    multiplier_18x18_or1_24 <= multiplier_18x18_mult_direct_out_1_24;
    multiplier_18x18_or1_23 <= multiplier_18x18_mult_direct_out_1_23;
    multiplier_18x18_or1_22 <= multiplier_18x18_mult_direct_out_1_22;
    multiplier_18x18_or1_21 <= multiplier_18x18_mult_direct_out_1_21;
    multiplier_18x18_or1_20 <= multiplier_18x18_mult_direct_out_1_20;
    multiplier_18x18_or1_19 <= multiplier_18x18_mult_direct_out_1_19;
    multiplier_18x18_or1_18 <= multiplier_18x18_mult_direct_out_1_18;
    multiplier_18x18_or1_17 <= multiplier_18x18_mult_direct_out_1_17;
    multiplier_18x18_or1_16 <= multiplier_18x18_mult_direct_out_1_16;
    multiplier_18x18_or1_15 <= multiplier_18x18_mult_direct_out_1_15;
    multiplier_18x18_or1_14 <= multiplier_18x18_mult_direct_out_1_14;
    multiplier_18x18_or1_13 <= multiplier_18x18_mult_direct_out_1_13;
    multiplier_18x18_or1_12 <= multiplier_18x18_mult_direct_out_1_12;
    multiplier_18x18_or1_11 <= multiplier_18x18_mult_direct_out_1_11;
    multiplier_18x18_or1_10 <= multiplier_18x18_mult_direct_out_1_10;
    multiplier_18x18_or1_9 <= multiplier_18x18_mult_direct_out_1_9;
    multiplier_18x18_or1_8 <= multiplier_18x18_mult_direct_out_1_8;
    multiplier_18x18_or1_7 <= multiplier_18x18_mult_direct_out_1_7;
    multiplier_18x18_or1_6 <= multiplier_18x18_mult_direct_out_1_6;
    multiplier_18x18_or1_5 <= multiplier_18x18_mult_direct_out_1_5;
    multiplier_18x18_or1_4 <= multiplier_18x18_mult_direct_out_1_4;
    multiplier_18x18_or1_3 <= multiplier_18x18_mult_direct_out_1_3;
    multiplier_18x18_or1_2 <= multiplier_18x18_mult_direct_out_1_2;
    multiplier_18x18_or1_1 <= multiplier_18x18_mult_direct_out_1_1;
    multiplier_18x18_or1_0 <= multiplier_18x18_mult_direct_out_1_0;
end Structure;
