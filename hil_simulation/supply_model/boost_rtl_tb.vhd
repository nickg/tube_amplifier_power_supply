LIBRARY ieee  ; 
    USE ieee.NUMERIC_STD.all  ; 
    USE ieee.std_logic_1164.all  ; 
    use ieee.math_real.all;

    use work.microinstruction_pkg.all;
    use work.processor_configuration_pkg.t_command;
    use work.float_type_definitions_pkg.all;
    use work.float_to_real_conversions_pkg.all;

package boost_model_pkg is
    constant inductance  : real := 50.0e-6;
    constant capacitance : real := 50.0e-6;
    constant rl          : real := 0.24;
    constant timestep    : real := 4.0e-6;
    constant boost_addr_offset : natural := 33;

    constant l : real := timestep/inductance;
    constant c : real := timestep/capacitance;

    type boost_model_record is record
        inductor_current : real;
        dc_link_voltage : real;
    end record;

    function calculate_boost (
        self          : boost_model_record;
        duty          : real;
        load_current  : real;
        input_voltage : real
    )
    return boost_model_record;
----------------------------------------------------------------
    constant variables : variable_array := init_variables(21) + boost_addr_offset;

    alias input_voltage_addr is variables(0);
    alias udc                is variables(1);
    alias current_addr       is variables(2);
    alias c_addr             is variables(3);
    alias l_addr             is variables(4);
    alias r_addr             is variables(5);

    alias d_x_udc_m_uin    is variables(6);
    alias uL               is variables(7);
    alias duty             is variables(8);
    alias ic               is variables(9);
    alias iload            is variables(10);

    constant boost_program : program_array :=(
        pipelined_block(
            program_array'(
            write_instruction(neg_mpy_add , d_x_udc_m_uin , 
                duty , udc , input_voltage_addr),
            write_instruction(mpy_add , ic ,
                duty , current_addr, iload)
            )
        ) &
        pipelined_block(
            program_array'(
            write_instruction(neg_mpy_add , uL , 
                current_addr , r_addr, d_x_udc_m_uin),
            write_instruction(mpy_add , udc ,
                ic , c_addr, udc)
            )
        ) &
        pipelined_block(
            write_instruction(mpy_add , current_addr , 
                uL , l_addr, current_addr)
        ) &
        write_instruction(program_end));

end package boost_model_pkg;

package body boost_model_pkg is

    function calculate_boost
    (
        self          : boost_model_record;
        duty          : real;
        load_current  : real;
        input_voltage : real
    )
    return boost_model_record
    is
        variable retval : boost_model_record := self;
    begin
        retval.inductor_current := retval.inductor_current + (input_voltage - retval.dc_link_voltage*duty - rl * retval.inductor_current)*l;
        retval.dc_link_voltage := retval.dc_link_voltage + (retval.inductor_current*duty + load_current)*c;

        return retval;
        
    end calculate_boost;

end package body boost_model_pkg;

------------------------------------------------------------------------

LIBRARY ieee  ; 
    USE ieee.NUMERIC_STD.all  ; 
    USE ieee.std_logic_1164.all  ; 
    use ieee.math_real.all;
    use std.textio.all;

LIBRARY ieee  ; 
    USE ieee.NUMERIC_STD.all  ; 
    USE ieee.std_logic_1164.all  ; 
    use ieee.math_real.all;
    use std.textio.all;

    use work.write_pkg.all;

library vunit_lib;
context vunit_lib.vunit_context;

    use work.multi_port_ram_pkg.all;

    use work.microinstruction_pkg.all;
    use work.simple_processor_pkg.all;
    use work.processor_configuration_pkg.all;
    use work.float_alu_pkg.all;
    use work.float_type_definitions_pkg.all;
    use work.float_to_real_conversions_pkg.all;

    use work.memory_processing_pkg.all;
    use work.float_assembler_pkg.all;
    use work.microinstruction_pkg.all;

    use work.boost_model_pkg.all;

entity boost_rtl_tb is
  generic (runner_cfg : string);
end;

architecture vunit_simulation of boost_rtl_tb is


    constant clock_period      : time    := 1 ns;
    
    signal simulator_clock     : std_logic := '0';
    signal simulation_counter  : natural   := 0;
    -----------------------------------
    -- simulation specific signals ----
    ------------------------------------------------------------------------

------------------------------------------------------------------------
    signal realtime   : real := 0.0;
    constant stoptime : real := 10.0e-3;

    constant initial_voltage : real := 100.0;

    function build_boost_model (filter_gain : real range 0.0 to 1.0; u_address, y_address, g_address, temp_address : natural) 
    return ram_array
    is
        variable retval : ram_array := (others => (others => '0'));
    begin
        for i in boost_program'range loop
            retval(i + 128) := boost_program(i);
        end loop;
        retval(input_voltage_addr ) := to_std_logic_vector(to_float(initial_voltage  )  ) ;
        retval(udc                ) := to_std_logic_vector(to_float(initial_voltage  )  ) ;
        retval(current_addr       ) := to_std_logic_vector(to_float(0.0  )  ) ;
        retval(c_addr             ) := to_std_logic_vector(to_float(c    )  ) ;
        retval(l_addr             ) := to_std_logic_vector(to_float(l    )  ) ;
        retval(r_addr             ) := to_std_logic_vector(to_float(rl    )  ) ;
        retval(duty               ) := to_std_logic_vector(to_float(0.5 )  ) ;
        retval(iload              ) := to_std_logic_vector(to_float(0.0  )  ) ;

        return retval;
    end build_boost_model;

------------------------------------------------------------------------
    constant ram_contents : ram_array := build_boost_model(0.05 , 0 , 0 , 0, 0);
------------------------------------------------------------------------

    signal self                     : simple_processor_record := init_processor;
    signal ram_read_instruction_in  : ram_read_in_record  := (0, '0');
    signal ram_read_instruction_out : ram_read_out_record ;
    signal ram_read_data_in         : ram_read_in_record  := (0, '0');
    signal ram_read_data_out        : ram_read_out_record ;
    signal ram_read_2_data_in       : ram_read_in_record  := (0, '0');
    signal ram_read_2_data_out      : ram_read_out_record ;
    signal ram_read_3_data_in       : ram_read_in_record  := (0, '0');
    signal ram_read_3_data_out      : ram_read_out_record ;
    signal ram_write_port           : ram_write_in_record ;

    signal processor_is_ready : boolean := false;

    signal counter  : natural range 0 to 7 := 7;
    signal counter2 : natural range 0 to 7 := 7;

    signal result1 : real := 0.0;
    signal result2 : real := 0.0;
    signal result3 : real := 0.0;

    signal float_alu : float_alu_record := init_float_alu;


    signal testi1 : real := 0.0;
    signal testi2 : real := 0.0;

    signal ready_pipeline : std_logic_vector(2 downto 0) := (others => '0');

    signal sequence_counter : natural := 0;

begin

------------------------------------------------------------------------
    simtime : process
    begin
        test_runner_setup(runner, runner_cfg);
        wait until realtime > stoptime;
        test_runner_cleanup(runner); -- Simulation ends here
        wait;
    end process simtime;	

    simulator_clock <= not simulator_clock after clock_period/2.0;
------------------------------------------------------------------------

    stimulus : process(simulator_clock)

        variable boost_model : boost_model_record := (0.0, initial_voltage);

        variable ref_input_voltage : real := 100.0;
        variable ref_load_current  : real := 0.0;
        variable ref_duty          : real := 0.5;

        variable used_instruction : t_instruction;
        variable inductor_current : real := 0.0;
        variable dc_link_voltage  : real := initial_voltage;
        file file_handler         : text open write_mode is "boost_rtl_tb.dat";


    begin
        if rising_edge(simulator_clock) then
            simulation_counter <= simulation_counter + 1;
            if simulation_counter = 0 then
                init_simfile(file_handler, ("time", "volt", "curr", "vref", "iref"));
            end if;

            --------------------
            create_simple_processor (
                self                     ,
                ram_read_instruction_in  ,
                ram_read_instruction_out ,
                ram_read_data_in         ,
                ram_read_data_out        ,
                ram_write_port           ,
                used_instruction);

            init_ram_read(ram_read_2_data_in);
            init_ram_read(ram_read_3_data_in);
            create_float_alu(float_alu);

            create_memory_process_pipeline(
             self                     ,
             float_alu                ,
             used_instruction         ,
             ram_read_instruction_out ,
             ram_read_data_in         ,
             ram_read_data_out        ,
             ram_read_2_data_in       ,
             ram_read_2_data_out      ,
             ram_read_3_data_in       ,
             ram_read_3_data_out      ,
             ram_write_port          );

             if ram_write_port.write_requested = '1' and ram_write_port.address = udc then
                 result3 <= to_real(to_float(ram_write_port.data));
             end if;

             if ram_write_port.write_requested = '1' and ram_write_port.address = current_addr then
                 result2 <= to_real(to_float(ram_write_port.data));
             end if;

            ------------------------------------------------------------------------
            ------------------------------------------------------------------------
            if simulation_counter = 0 then
                request_processor(self, 128);
                realtime <= realtime + timestep;
                write_to(file_handler,(realtime, result3, result2, boost_model.dc_link_voltage, boost_model.inductor_current));
                boost_model := calculate_boost(self => boost_model, duty => ref_duty, load_current => ref_load_current, input_voltage => ref_input_voltage);
            end if;

            ready_pipeline <= ready_pipeline(ready_pipeline'left-1 downto 0) & '0';
            if program_is_ready(self) then
                ready_pipeline(0) <= '1';
            end if;

            if ready_pipeline(ready_pipeline'left) = '1' then
                realtime <= realtime + timestep;
                boost_model := calculate_boost(boost_model, ref_duty, ref_load_current, ref_input_voltage);
                write_to(file_handler,(realtime, result3, result2, boost_model.dc_link_voltage, boost_model.inductor_current));
                request_processor(self, 128);
                CASE sequence_counter is
                    WHEN 0 =>
                        if realtime > 2.0e-3 then
                            ref_duty := 0.25;
                            write_data_to_ram(ram_write_port, duty, to_std_logic_vector(to_float(ref_duty)));

                            sequence_counter <= sequence_counter + 1;
                        end if;
                    WHEN 1 =>
                        if realtime > 4.0e-3 then
                            ref_input_voltage := 120.0;
                            write_data_to_ram(ram_write_port, input_voltage_addr, to_std_logic_vector(to_float(ref_input_voltage)));
                            sequence_counter <= sequence_counter + 1;
                        end if;
                    WHEN 2 =>
                        if realtime > 6.0e-3 then
                            ref_load_current := -10.0;
                            write_data_to_ram(ram_write_port, iload, to_std_logic_vector(to_float(ref_load_current)));
                            sequence_counter <= sequence_counter + 1;
                        end if;
                    WHEN others => --do nothing
                end CASE;
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
