library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

    use work.multiplier_pkg.all;

entity multiplier is
    port (
        multiplier_clocks : in multiplier_clock_group;

        multiplier_data_in : in multiplier_data_input_group;
        multiplier_data_out : out multiplier_data_output_group
    );
end entity;

architecture rtl of multiplier is


    signal mult_result : result_array(0 to 0);
    signal mult_a, mult_b : sign_array(0 to 1);
    component multiplier_18x18 IS
	PORT
	(
		clock		: IN STD_LOGIC ;
		dataa		: IN STD_LOGIC_VECTOR (17 DOWNTO 0);
		datab		: IN STD_LOGIC_VECTOR (17 DOWNTO 0);
		result		: OUT STD_LOGIC_VECTOR (35 DOWNTO 0)
	);
    END component;

	signal dataa		: STD_LOGIC_VECTOR (17 DOWNTO 0);
	signal datab		: STD_LOGIC_VECTOR (17 DOWNTO 0);
	signal result		:  STD_LOGIC_VECTOR (35 DOWNTO 0);

    signal multiplier_counter : natural range 0 to 9; 

begin

    test_multiplier : process(multiplier_clocks.dsp_clock)

    begin
        if rising_edge(multiplier_clocks.dsp_clock) then

            mult_a(0) <= to_signed(multiplier_data_in.mult_a,18);
            mult_b(0) <= to_signed(multiplier_data_in.mult_b,18);
            multiplier_data_out.multiplier_result <= mult_a(0) * mult_b(0);


            if multiplier_data_in.multiplication_is_requested then
                multiplier_counter <= 3;
            end if;

            if multiplier_counter > 0 then
                multiplier_counter <= multiplier_counter - 1;
            end if;

            multiplier_data_out.multiplier_is_ready <= false;
            if multiplier_counter = 1 then
                multiplier_data_out.multiplier_is_ready <= true;
            end if;

        end if; --rising_edge
    end process test_multiplier;	

end rtl;
