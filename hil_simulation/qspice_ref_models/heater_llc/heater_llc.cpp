// Automatically generated C++ file on Mon May 20 07:05:37 2024
//
#include <cmath>
#include "../../cpp_sources/modulator/modulator.hpp"
#include "../../cpp_sources/carrier_generation/carrier_generation.hpp"
#include "../../cpp_sources/feedback_control/pi_control/pi_control.hpp"

const double
    gate_hi_voltage = 6.0   ,
    gate_lo_voltage = -3.3  ,
    deadtime        = 50e-9 ,
    Ts              = 1.0/110.0e3 ,
    duty            = 0.5;

Modulator modulator1(Ts, duty, gate_hi_voltage, gate_lo_voltage, deadtime);
Modulator modulator2(Ts, duty, gate_hi_voltage, gate_lo_voltage, deadtime);

const double 
    vkp = 0.0005,
    vki = 0.0005;

pi_control voltage_control(vkp, vki, 1.0);

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

extern "C" __declspec(dllexport) void heater_llc(void **opaque, double t, union uData *data)
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
   double &iload    = data[9].d; // output
// Implement module evaluation code here:

    if (modulator2.synchronous_sample_called(t))
    {
        double verror = 6.3-vdc;
        const double low_limit = -1;
        const double high_limit = 1;
        double piout = voltage_control.calculate_pi_out(verror, low_limit, high_limit);
        vout = piout;

    }
    /* if (modulator1.synchronous_sample_called(t)) */
    /* { */
    /*     modulator1.set_frequency(175e3 - (50e3*vout)); */
    /* } */


   vin = 400.0;
   modulator1.update(t);
   modulator2.update(t);
   carrier1 = modulator1.get_carrier();
   carrier2 = modulator2.get_carrier();
   gate1 = modulator1.getPWM();
   gate2 = modulator1.getPWMLo();
   gate3 = gate_lo_voltage;
   gate4 = gate_lo_voltage;
   iload = 0.0;

   // excitation 
   iload = -1.0;
   if (t > 1.5e-3)   iload = -8.5;
   /* if (t > 4.5e-3) iload = 1.0; */
   /* if (t > 5.5e-3) iload = -5.0; */
   /* if (t > 7.5e-3) iload = 5.0; */
   /* if (t > 9.5e-3) iload = -1.0; */

}
