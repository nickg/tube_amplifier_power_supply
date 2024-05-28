LIBRARY ieee  ; 
    USE ieee.NUMERIC_STD.all  ; 
    USE ieee.std_logic_1164.all  ; 
    use std.textio.all;
    use ieee.math_real.all;

library vunit_lib;
context vunit_lib.vunit_context;

    use work.write_pkg.all;
    use work.pfc_model_pkg.all;

    use work.microinstruction_pkg.all;
    use work.multi_port_ram_pkg.all;
    use work.simple_processor_pkg.all;
    use work.processor_configuration_pkg.all;
    use work.float_alu_pkg.all;
    use work.float_type_definitions_pkg.all;
    use work.float_to_real_conversions_pkg.all;

    use work.memory_processing_pkg.all;
    use work.microinstruction_pkg.all;

entity rtl_model_tube_power_tb is
  generic (runner_cfg : string);
end;

architecture vunit_simulation of rtl_model_tube_power_tb is

    constant clock_period      : time      := 1 ns;
    signal simulator_clock     : std_logic := '0';
    signal simulation_counter  : natural   := 0;
    -----------------------------------
    -- simulation specific signals ----
    signal realtime : real := 0.0;
    constant timestep : real := 350.0/128.0e6;

    signal sequencer : natural := 1;

    signal pfc : pfc_record := (
        (others => 0.0) ,
        (others => 0.0) ,
        0.0             ,
        100.0);

    signal duty   : real := 0.5;
    signal load_r : real := 400.0**2/50.0;

    signal r            : real := 115.0e-3;
    signal l            : real := timestep/20.0e-6;
    signal c            : real := timestep/0.68e-6;
    signal dc_link_gain : real := timestep/320.0e-6;
    signal pri_l_gain   : real := timestep/500.0e-6;
    signal uin          : real := 100.0;

    signal mcu                     : simple_processor_record := init_processor;
    signal ram_read_instruction_in  : ram_read_in_record  := (0, '0');
    signal ram_read_instruction_out : ram_read_out_record ;
    signal ram_read_data_in         : ram_read_in_record  := (0, '0');
    signal ram_read_data_out        : ram_read_out_record ;
    signal ram_read_2_data_in       : ram_read_in_record  := (0, '0');
    signal ram_read_2_data_out      : ram_read_out_record ;
    signal ram_read_3_data_in       : ram_read_in_record  := (0, '0');
    signal ram_read_3_data_out      : ram_read_out_record ;
    signal ram_write_port           : ram_write_in_record ;

    signal float_alu : float_alu_record := init_float_alu;

    type pfc_model_record is record
        l1, c1, l2, c2, l3, c_dc_link, duty, lc1_current, lc2_current, i3, lc1_voltage, lc2_voltage, dc_link_voltage, rl1, rload : integer;
    end record;
    /* constant pfc_mem : pfc_model_record := (0,1,2,3,4,5,6); */

    function pfc_model_program
    (
        pfc : pfc_model_record ;
        input_voltage_addr : natural;
        load_current : natural
    )
    return ram_array
    is
        subtype pfc_model_mem is integer_vector(0 to 20);
        constant tuitui : pfc_model_mem := (others => 0);

        function init_mem
        (
            input : integer_vector 
        )
        return integer_vector
        is
            variable retval : integer_vector(input'range);
        begin
            for i in input'range loop
                retval(i) := i;
            end loop;

            return retval;
            
        end init_mem;
        constant mem : integer_vector(pfc_model_mem'range) := init_mem(tuitui);

        alias sum_addr      : integer_vector(0 to 5) is mem(0 to 5);
        alias mult_add_addr : integer_vector(0 to 3) is mem(6 to 9);
        alias mult_addr     : integer_vector(0 to 9) is mem(10 to 19);

        constant program : program_array :=(
        pipelined_block(
            program_array'(
                write_instruction(sub     , sum_addr(0)      , input_voltage_addr  , pfc.lc1_voltage) ,
                write_instruction(mpy_add , mult_add_addr(0) , pfc.dc_link_voltage , pfc.duty         , pfc.lc2_voltage) ,
                write_instruction(mpy_add , mult_add_addr(1) , pfc.i3              , pfc.duty         , load_current)    ,
                write_instruction(sub     , sum_addr(1)      , pfc.lc1_current     , pfc.lc2_current) ,
                write_instruction(sub     , sum_addr(3)      , pfc.lc2_current     , pfc.i3)          ,
                write_instruction(sub     , sum_addr(2)      , pfc.lc1_voltage     , pfc.lc2_voltage) ,
                write_instruction(mpy     , mult_addr(0)     , pfc.rl1             , pfc.lc1_current) ,
                write_instruction(mpy     , mult_addr(1)     , pfc.rload           , pfc.lc2_current) ,
                write_instruction(mpy     , mult_addr(2)     , pfc.rl1             , pfc.lc2_current)
        ))&
        pipelined_block(
            program_array'(
                write_instruction(mpy , mult_addr(6) , sum_addr(0)      , pfc.l3)        ,
                write_instruction(mpy , mult_addr(8) , mult_add_addr(0) , pfc.l3)        ,
                write_instruction(mpy , mult_addr(9) , mult_add_addr(1) , pfc.c_dc_link) ,
                write_instruction(mpy , mult_addr(4) , sum_addr(1)      , pfc.c1)        ,
                write_instruction(mpy , mult_addr(5) , sum_addr(3)      , pfc.c2)        ,
                write_instruction(mpy , mult_addr(3) , pfc.rload        , pfc.i3)        ,
                write_instruction(mpy , mult_addr(7) , sum_addr(2)      , pfc.c2)        ,
                write_instruction(add , sum_addr(4)  , mult_addr(0)     , mult_addr(1))  ,
                write_instruction(add , sum_addr(5)  , mult_addr(2)     , mult_addr(3))
        ))&
        pipelined_block(
            program_array'(
                write_instruction(mpy_add, mult_add_addr(2), sum_addr(4), pfc.l3, mult_addr(6)),
                write_instruction(mpy_add, mult_add_addr(3), sum_addr(5), pfc.l3, mult_addr(7)))
        ));

        variable retval : ram_array := (others => (others => '0'));
    begin
        for i in program'range loop
            retval(i+128) := program(i);
        end loop;

        return retval;
        
    end pfc_model_program;

    constant ram_contents : ram_array := (others => (others => '0'));

begin

------------------------------------------------------------------------
    simtime : process
    begin
        test_runner_setup(runner, runner_cfg);
        wait until realtime >= 60.0e-3;
        test_runner_cleanup(runner); -- Simulation ends here
        wait;
    end process simtime;	

    simulator_clock <= not simulator_clock after clock_period/2.0;
------------------------------------------------------------------------

    stimulus : process(simulator_clock)
    ------------------------------
    ------------------------------
        type pfc_array is array (natural range <>) of pfc_record;
        variable k_pfc : pfc_array(1 to 4);

        file file_handler : text open write_mode is "rtl_model_tube_power_tb.dat";

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
            variable sum      : real_vector (0 to 5);
            variable mult_add : real_vector (0 to 3);
            variable mult     : real_vector (0 to 9);
        begin

            -- block1 
            sum(0)      := input_voltage - self.lc1.voltage;
            mult_add(0) := -self.dc_link*duty + self.lc2.voltage ;
            mult_add(1) := duty*self.i3 - load_current;
            sum(1)      := self.lc1.current - self.lc2.current;
            sum(3)      := self.lc2.current - self.i3;
            sum(2)      := self.lc1.voltage - self.lc2.voltage;
            mult(0)     := -r_l   * self.lc1.current;
            mult(1)     := r_load * self.lc2.current;
            mult(2)     := -r_l   * self.lc2.current;

            -- block2 
            mult(6) := sum(0)*l_gain;
            mult(8) := mult_add(0)*pri_l_gain;
            mult(9) := mult_add(1)*dc_link_gain;
            mult(4) := sum(1)*c_gain;
            mult(5) := sum(3)*c_gain;
            mult(3) := r_load * self.i3;
            mult(7) := sum(2) * l_gain;
            sum(4)  := mult(0) + mult(1);
            sum(5)  := mult(2) + mult(3);

            -- block3 
            mult_add(2) := sum(4) * l_gain + mult(6);
            mult_add(3) := sum(5) * l_gain + mult(7);

            retval.lc1.current := mult_add(2);
            retval.lc1.voltage := mult(4);

            retval.lc2.current := mult_add(3);
            retval.lc2.voltage := mult(5);

            retval.i3      := mult(8);
            retval.dc_link := mult(9);

            return retval;
        end calculate_pfc;

    begin
        if rising_edge(simulator_clock) then
            simulation_counter <= simulation_counter + 1;
            if simulation_counter = 0 then
                init_simfile(file_handler, ("time", "volt", "curr", "load", "dcur"));
            end if;

            case sequencer is
                when 0 =>
                    k_pfc(1) := calculate_pfc(pfc                , l , c , dc_link_gain , pri_l_gain , r , 0.0 , uin , pfc.dc_link/load_r , duty);
                    k_pfc(2) := calculate_pfc(pfc + k_pfc(1)/2.0 , l , c , dc_link_gain , pri_l_gain , r , 0.0 , uin , pfc.dc_link/load_r , duty);
                    k_pfc(3) := calculate_pfc(pfc + k_pfc(2)/2.0 , l , c , dc_link_gain , pri_l_gain , r , 0.0 , uin , pfc.dc_link/load_r , duty);
                    k_pfc(4) := calculate_pfc(pfc + k_pfc(3)     , l , c , dc_link_gain , pri_l_gain , r , 0.0 , uin , pfc.dc_link/load_r , duty);

                    pfc <= pfc + (k_pfc(1) + k_pfc(2)/0.5 + k_pfc(3)/0.5 + k_pfc(4))/6.0;
                    /* pfc <= pfc + k_pfc(2); */

                    realtime <= realtime + timestep;
                    write_to(file_handler,(realtime, pfc.dc_link, pfc.lc2.current, pfc.dc_link/load_r, duty*pfc.i3));

                when others => --do nothing
            end case;

            if realtime > 15.0e-3 then duty   <= 0.25; end if;
            if realtime > 30.0e-3 then load_r <= 500.0; end if;
            if realtime > 40.0e-3 then uin    <= 120.0; end if;

            sequencer <= sequencer + 1;
            if sequencer > 0 then
                sequencer <= 0;
            end if;

        end if; -- rising_edge
    end process stimulus;	
------------------------------------------------------------------------
    u_mpram : entity work.ram_read_x4_write_x1
    generic map(ram_contents)
    port map(
    simulator_clock          ,
    ram_read_instruction_in  ,
    ram_read_instruction_out ,
    ram_read_data_in         ,
    ram_read_data_out        ,
    ram_read_2_data_in       ,
    ram_read_2_data_out      ,
    ram_read_3_data_in       ,
    ram_read_3_data_out      ,
    ram_write_port);
------------------------------------------------------------------------
end vunit_simulation;
