// Automatically generated C++ file on Sat May 18 10:58:14 2024
//
// To build with Digital Mars C++ Compiler:
//
//    dmc -mn -WD dual_half_bridge.cpp kernel32.lib

const double
    gate_hi_voltage = 6.0   ,
    gate_lo_voltage = -3.3  ,
    deadtime        = 50e-9 ,
    Ts              = 1.0/30.0e3 ,
    duty            = 0.5;

#include "../../cpp_sources/modulator/modulator.hpp"

union uData
{
   bool b;
   char c;
   unsigned char uc;
   short s;
   unsigned short us;
   int i;
   unsigned int ui;
   float f;
   double d;
   long long int i64;
   unsigned long long int ui64;
   char *str;
   unsigned char *bytes;
};


/* Modulator modulator(Ts, duty, gate_hi_voltage, gate_lo_voltage, deadtime); */

int __stdcall DllMain(void *module, unsigned int reason, void *reserved) { return 1; }

// #undef pin names lest they collide with names in any header file(s) you might include.
#undef vdc
#undef gate1
#undef gate2
#undef carrier2
#undef vin
#undef carrier1
#undef gate3
#undef gate4
#undef vout

extern "C" __declspec(dllexport) void dual_half_bridge(void **opaque, double t, union uData *data)
{
   double  vdc      = data[0].d; // input
   double &gate1    = data[1].d; // output
   double &gate2    = data[2].d; // output
   double &carrier2 = data[3].d; // output
   double &vin      = data[4].d; // output
   double &carrier1 = data[5].d; // output
   double &gate3    = data[6].d; // output
   double &gate4    = data[7].d; // output
   double &vout     = data[8].d; // output
// Implement module evaluation code here:

   /* modulator.update(t); */
   vin = 400.0;
}
