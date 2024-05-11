library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

package pfc_model_pkg is

    type lc_record is record
        current : real;
        voltage : real;
    end record;

    type pfc_record is record
        lc1     : lc_record;
        lc2     : lc_record;
        i3      : real;
        dc_link : real;
    end record;

    function "+" ( left, right : pfc_record)
        return pfc_record;

    function "/" ( left : pfc_record; right : real)
        return pfc_record;

    function calculate_pfc (
        self          : pfc_record;
        l_gain        : real ;
        c_gain        : real ;
        dc_link_gain  : real ;
        pri_l_gain    : real ;
        r_l           : real ;
        r_load        : real ;
        input_voltage : real ;
        load_current  : real ;
        duty          : real range -1.0 to 1.0
    )
    return pfc_record;

    function calculate_lc (
        lc : lc_record;
        l_gain : real;
        c_gain : real;
        r_l : real;
        r_load : real;
        input_voltage : real;
        load_current : real)
    return lc_record;

end package pfc_model_pkg;

package body pfc_model_pkg is

    function "+"
    (
        left, right : pfc_record
    )
    return pfc_record
    is
        variable retval : pfc_record;
    begin
        retval.lc1.current := left.lc1.current + right.lc1.current;
        retval.lc1.voltage := left.lc1.voltage + right.lc1.voltage;
        retval.lc2.current := left.lc2.current + right.lc2.current;
        retval.lc2.voltage := left.lc2.voltage + right.lc2.voltage;
        retval.i3          := left.i3          + right.i3;
        retval.dc_link     := left.dc_link     + right.dc_link;

        return retval;
    end "+";

    function "/"
    (
        left : pfc_record;
        right : real
        
    )
    return pfc_record
    is
        variable retval : pfc_record;
    begin
        retval.lc1.current := left.lc1.current/right;
        retval.lc1.voltage := left.lc1.voltage/right;
        retval.lc2.current := left.lc2.current/right;
        retval.lc2.voltage := left.lc2.voltage/right;
        retval.i3          := left.i3/right;
        retval.dc_link     := left.dc_link/right;

        return retval;
        
    end "/";

        function calculate_pfc
        (
            self          : pfc_record;
            l_gain        : real ;
            c_gain        : real ;
            dc_link_gain  : real ;
            pri_l_gain    : real ;
            r_l           : real ;
            r_load        : real ;
            input_voltage : real ;
            load_current  : real ;
            duty          : real range -1.0 to 1.0
        )
        return pfc_record
        is
            variable retval : pfc_record := self;
        begin

            -- retval.lc1     := calculate_lc(self.lc1 , l , c , r , 0.0 , uin             , self.lc2.current);

            retval.lc1.current := ((input_voltage - self.lc1.voltage) - r_l*self.lc1.current + r_load * 0.0) * l_gain;
            retval.lc1.voltage := (self.lc1.current - self.lc2.current)*c_gain;

            -- retval.lc2     := calculate_lc(self.lc2 , l , c , r , 0.0 , self.lc1.voltage , pfc.i3);

            retval.lc2.current := ((self.lc1.voltage - self.lc2.voltage) - r_l*self.lc2.current + r_load * 0.0) * l_gain;
            retval.lc2.voltage := (self.lc2.current - self.i3)*c_gain;

            retval.i3      := (self.lc2.voltage - self.dc_link*duty)*pri_l_gain;
            retval.dc_link := (duty*self.i3 - load_current)*dc_link_gain;

            return retval;
        end calculate_pfc;

    function calculate_lc
    (
        lc : lc_record;
        l_gain : real;
        c_gain : real;
        r_l : real;
        r_load : real;
        input_voltage : real;
        load_current : real
    )
    return lc_record
    is
        variable retval : lc_record;
    begin

        retval.current := ((input_voltage - lc.voltage) - r_l*lc.current + r_load * load_current) * l_gain;
        retval.voltage := (lc.current - load_current)*c_gain;

        return retval;
        
    end calculate_lc;

end package body pfc_model_pkg;
------------------------------------------------------------------------
------------------------------------------------------------------------
