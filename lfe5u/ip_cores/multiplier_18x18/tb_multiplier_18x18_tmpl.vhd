-- VHDL testbench template generated by SCUBA Diamond (64-bit) 3.11.2.446
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

use IEEE.math_real.all;

use IEEE.numeric_std.all;

entity tb is
end entity tb;


architecture test of tb is 

    component multiplier_18x18
        port (Clock: in std_logic; ClkEn: in std_logic; 
        Aclr: in std_logic; DataA : in std_logic_vector(17 downto 0); 
        DataB : in std_logic_vector(17 downto 0); 
        Result : out std_logic_vector(35 downto 0)
    );
    end component;

    signal Clock: std_logic := '0';
    signal ClkEn: std_logic := '0';
    signal Aclr: std_logic := '0';
    signal DataA : std_logic_vector(17 downto 0) := (others => '0');
    signal DataB : std_logic_vector(17 downto 0) := (others => '0');
    signal Result : std_logic_vector(35 downto 0);
begin
    u1 : multiplier_18x18
        port map (Clock => Clock, ClkEn => ClkEn, Aclr => Aclr, DataA => DataA, 
            DataB => DataB, Result => Result
        );

    Clock <= not Clock after 5.00 ns;

    process

    begin
      ClkEn <= '1' ;
      wait;
    end process;

    process

    begin
      Aclr <= '1' ;
      wait for 100 ns;
      Aclr <= '0' ;
      wait;
    end process;

    process

    begin
      DataA <= (others => '0') ;
      for i in 0 to 200 loop
        wait until Clock'event and Clock = '1';
        DataA <= DataA + '1' after 1 ns;
      end loop;
      wait;
    end process;

    process

    begin
      DataB <= (others => '0') ;
      for i in 0 to 200 loop
        wait until Clock'event and Clock = '1';
        DataB <= DataB + '1' after 1 ns;
      end loop;
      wait;
    end process;

end architecture test;
