# Tube amplifier power supply
<img src="docs/figures/putkipoweri.jpg" alt="Tube Power" style="width:80%; height:80%;">
This is a repository for a tube amplifier power supply FPGA control. The power supply consists of a PFC, 6.3V/10A LLC, 420V/1A dual active half bridge and an fpga to contorl them. The auxiliary supplies are also provided by a DCM flyback converter built around IW1818. This power supply was designed originally during university studies and finished in 2017. 

For more detailed information, please refer to the [PDF documentation](docs/tube_amp_power.pdf).

The power supply was never installed and the original repository was lost at some point hence this repository picks up at the point which was recovered from some old copy.

## hVHDL libraries
 [hvhdl project on GitHub](https://github.com/hvhdl) has the required fixed and floating point math libraries and microcode processor libraries so we will refactor the old control code to use them. The hVHDL libraries come with VUnit tests hence the code is easier to refactor to use the existing tested libraries than to simulate the functionality with the implementations that are present in this repository.

## HIL simulation and its verification against QSPICE simulation
<img src="docs/figures/boost_qspice_vs_vhdl.png" alt="Boost simulations" style="width:40%; height:40%;">
Since the system is relatively complicated, a HIL simulation will be created to test overall control and trip functionality with target hardware but without full power. The VHDL HIL simulation models are verified by comparing the HIL simulation resultswith same simulations that are run using QSPICE. QSPICE allows us to write the control and modulation code in C++ which are compiled to DLL and run inside the spice simulation. 

The HiL simulation will be done using the hVHDL microcode processor libraries in order to run the simulation in floating point. There are various versions of the control hardware available so we will at least run it using Spartan 7 and Cyclone 10 LP.

The C++ sources for QSPICE model verification requires CMake and the .dll needs to be generated with 32bit platform. 
Example using Visual Studio 

cmake -G "Visual Studio 17 2022" -DCMAKE_GENERATOR_PLATFORM=Win32 ..

the project can be built then using

cmake --build .

how to run build

1. mkdir build
2. cd build
3. cmake -G "Visual Studio 17 2022" -DCMAKE_GENERATOR_PLATFORM=Win32 ..

The QSPICE simulations can be found in hil_simulation/qspice_ref_models/

The models are done individually and the combined model can be found in the guitar_power_supply
