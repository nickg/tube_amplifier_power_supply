# Tube amplifier power supply

This is a repository for a tube amplifier power supply FPGA control. The power supply consists of a PFC, 6.3V/10A LLC, 420V/1A dual active half bridge and an fpga to contorl them. The auxiliary supplies are also provided by a DCM flyback converter built around IW1818

This power supply was designed originally during university studies and finished in 2017. There was a report on the design which is part of this repository tube_amp_power.pdf. The power supply was never installed and the original repository was lost at some point hence this repository picks up at the point which was recovered from some old copy. I will probably make some sort of writeup since this is exactly the same situation which is common when some old legacy codebase needs to be maintained :)

## Refactoring
The original master branch was lost, so we will recreate the design with the current development branch. The hardware has been verified to work hence we know that the ad timings are correct. Originally code was tested and developed with hardware directly, hence we will add simulations and tests to make the redesign substantially easier.

## hVHDL libraries
The hVHDL project has required DSP and math libraries so we will refactor the code to use them. The hVHDL libraries come with tests hence the code is easier to refactor to use the existing tested libraries than to simulate the functionality with the implementations that are present in this repository.

## HIL simulation
Since the system is relatively complicated, a HIL simulation will be created to test overall functionality. This includes trips and control loops. The modeling will be quite simple since the main idea is to test at system level, ie whatever is visible from uart.

The HiL simulation will be done using the microprocessor libraries in order to run the simulation in floating point.

Building the hil simulation C++ sources for QSPICE requires CMake and the .dll needs to be generated with 32bit platform. Example using Visual Studio 
cmake -G "Visual Studio 17 2022" -DCMAKE_GENERATOR_PLATFORM=Win32 ..
the project can be built then using
cmake --build .

## Overall system level 

test if code snippet works.

```vhdl
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

    use work.system_clocks_pkg.all;
    use work.system_control_pkg.all;

entity top is
    port(
	    xclk : in std_logic;
        system_control_FPGA_in  : in system_control_FPGA_input_group;
        system_control_FPGA_out : out system_control_FPGA_output_group
    );
end top;

architecture behavioral of top is

    signal system_clocks : system_clock_group;

begin
------------------------------------------------------------------------
    clocks : entity work.pll_wrapper
	port map
	(
		xclk,
        system_clocks
	);
------------------------------------------------------------------------
    u_system_control : entity work.system_control
        port map(
            system_clocks,
            system_control_FPGA_in,
            system_control_FPGA_out
        );
------------------------------------------------------------------------
end behavioral;
```

