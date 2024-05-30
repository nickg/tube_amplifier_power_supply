LIBRARY ieee  ; 
    USE ieee.NUMERIC_STD.all  ; 
    USE ieee.std_logic_1164.all  ; 
    use ieee.math_real.all;
    use std.textio.all;

    use work.write_pkg.all;

library vunit_lib;
context vunit_lib.vunit_context;

    use work.microinstruction_pkg.all;
    use work.multi_port_ram_pkg.all;
    use work.simple_processor_pkg.all;
    use work.processor_configuration_pkg.all;
    use work.float_alu_pkg.all;
    use work.float_type_definitions_pkg.all;
    use work.float_to_real_conversions_pkg.all;

    use work.memory_processing_pkg.all;
    use work.float_assembler_pkg.all;
    use work.microinstruction_pkg.all;

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
    signal realtime : real := 0.0;
    signal timestep : real := 1.7e-6;

    signal uin : real := 0.0;
    signal uc1 : real := 0.0;
    constant rl1 : real := 0.1;
    constant rc1 : real := 0.015;

    signal current : real := 0.0;
    signal voltage : real := 0.0;
    signal input_voltage : real := 1.0;
    constant r : real := 0.56;
    constant l : real := timestep/50.0e-6;
    constant c : real := timestep/50.0e-6;
    signal sequencer : natural := 0;

    constant variables : variable_array := init_variables(21) + 33;

    alias input_voltage_addr is variables(0);
    alias voltage_addr       is variables(1);
    alias current_addr       is variables(2);
    alias c_addr             is variables(3);
    alias l_addr             is variables(4);
    alias r_addr             is variables(5);
    alias i1_x_ra_plus_uc    is variables(6);
    alias sub1_addr          is variables(7);
    alias uin_minus_uc1      is variables(8);

    alias d_x_udc_m_uin    is variables(9);
    alias uL               is variables(10);
    alias duty             is variables(11);
    alias vin              is input_voltage_addr;
    alias inductor_current is current_addr;
    alias l_gain           is l_addr;
    alias c_gain           is c_addr;
    alias ic               is variables(16);
    alias udc              is voltage_addr;
    alias rl               is r_addr;
    alias iload            is variables(19);
    alias duty2            is variables(20);

    constant boost_program : program_array :=(
        pipelined_block(
            write_instruction(mpy_add , d_x_udc_m_uin , 
                duty , udc , vin)
        ) &
        pipelined_block(
            write_instruction(mpy_add , uL , 
                inductor_current , rl, d_x_udc_m_uin)
        ) &
        pipelined_block(
            write_instruction(mpy_add , inductor_current , 
                uL , l_gain, inductor_current)
        ) &
        pipelined_block(
            write_instruction(mpy_add , ic ,
                duty2 , inductor_current, iload)
        ) &
        pipelined_block(
            write_instruction(mpy_add , udc ,
                ic , c_gain, udc)
        ) &
        write_instruction(program_end));

    function build_lcr_sw (filter_gain : real range 0.0 to 1.0; u_address, y_address, g_address, temp_address : natural) return ram_array
    is

        ------------------------------
        variable retval : ram_array := (others => (others => '0'));
    begin
        for i in boost_program'range loop
            retval(i + 128) := boost_program(i);
        end loop;
        retval(input_voltage_addr ) := to_std_logic_vector(to_float(1.0  )  ) ;
        retval(voltage_addr       ) := to_std_logic_vector(to_float(1.1  )  ) ;
        retval(current_addr       ) := to_std_logic_vector(to_float(0.0  )  ) ;
        retval(c_addr             ) := to_std_logic_vector(to_float(c    )  ) ;
        retval(l_addr             ) := to_std_logic_vector(to_float(l    )  ) ;
        retval(r_addr             ) := to_std_logic_vector(to_float(-0.2    )  ) ;
        retval(i1_x_ra_plus_uc    ) := to_std_logic_vector(to_float(0.0  )  ) ;
        retval(sub1_addr          ) := to_std_logic_vector(to_float(0.0  )  ) ;
        retval(duty               ) := to_std_logic_vector(to_float(-0.5 )  ) ;
        retval(duty2              ) := to_std_logic_vector(to_float(0.5 )  ) ;
        retval(iload              ) := to_std_logic_vector(to_float(0.0  )  ) ;

        return retval;
    end build_lcr_sw;

------------------------------------------------------------------------
    constant ram_contents : ram_array := build_lcr_sw(0.05 , 0 , 0 , 0, 0);
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

    signal counter : natural range 0 to 7 :=7;
    signal counter2 : natural range 0 to 7 :=7;

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
        wait until realtime > 4.0e-3;
        /* check(abs(result3-voltage) < 0.01); */
        test_runner_cleanup(runner); -- Simulation ends here
        wait;
    end process simtime;	

    simulator_clock <= not simulator_clock after clock_period/2.0;
------------------------------------------------------------------------

    stimulus : process(simulator_clock)
        variable used_instruction : t_instruction;
        file file_handler : text open write_mode is "boost_rtl_tb.dat";
        variable dil1, dil2, dil3 : real; 
        constant uin : real := 1.0;
        variable il1 : real := 0.0;
        variable il2 : real := 0.0;
        variable il3 : real := 0.0;
        constant rc2 : real := 0.15;
        constant L1 : real := timestep/10.0e-6;
    begin
        if rising_edge(simulator_clock) then
            simulation_counter <= simulation_counter + 1;
            if simulation_counter = 0 then
                init_simfile(file_handler, ("time", "volt", "curr", "vref", "iref"));
            end if;

            CASE sequencer is
                WHEN 0 => 
                    /* dil1 := ((uin - uc1)      - (rl1+rc1)*il1 + rc2*il2)*L1; */
                    /* dil2 := ((uc1 - uc2)      + rc1*il1 - (rc2 + rl2 + rc3)*i2 + rc3*i3)*L2; */
                    /* dil3 := ((uc2 - duty*udc) + rc2*il2 - (rc3 + rl3 + rbridge)*i3)*L3; */
                    /* il1  := il1 + di11; */
                    /* il2  := il2 + di12; */
                    /* il3  := il3 + di13; */
                    /* uc1  := uc1 + (il1 - il2) * c1; */
                    /* uc2  := uc2 + (il2 - il3) * c2; */
                    /* udc  := udc + (il3*duty - iload) * cdc; */

                    /* current   <= mac3; */
                    /* voltage   <= mac2; */
                    sequencer <= sequencer + 1;
                WHEN others => -- do nothing
            end CASE;

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

             if ram_write_port.write_requested = '1' and ram_write_port.address = voltage_addr then
                 result3 <= to_real(to_float(ram_write_port.data));
             end if;

             if ram_write_port.write_requested = '1' and ram_write_port.address = current_addr then
                 result2 <= to_real(to_float(ram_write_port.data));
             end if;

        ------------------------------------------------------------------------
        ------------------------------------------------------------------------
            ------------------------------------------------------------------------
            -- test signals
            ------------------------------------------------------------------------
            if simulation_counter = 0 then
                sequencer <= 0;
                request_processor(self, 128);
                realtime <= realtime + timestep;
                write_to(file_handler,(realtime, result3, result2, voltage, current));
            end if;

            ready_pipeline <= ready_pipeline(ready_pipeline'left-1 downto 0) & '0';
            if program_is_ready(self) then
                ready_pipeline(0) <= '1';
            end if;

            if ready_pipeline(ready_pipeline'left) = '1' then
                sequencer <= 0;
                realtime <= realtime + timestep;
                write_to(file_handler,(realtime, result3, result2, voltage, current));
                request_processor(self, 128);
                CASE sequence_counter is
                    WHEN 0 =>
                        if realtime > 2.0e-3 then
                            write_data_to_ram(ram_write_port, input_voltage_addr, to_std_logic_vector(to_float(1.5)));
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
