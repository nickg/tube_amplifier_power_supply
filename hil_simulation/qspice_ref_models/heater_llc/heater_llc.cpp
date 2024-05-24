// Automatically generated C++ file on Mon May 20 07:05:37 2024
//
#include <cmath>
#include "../../cpp_sources/modulator/modulator.hpp"
#include "../../cpp_sources/carrier_generation/carrier_generation.hpp"
#include "../../cpp_sources/feedback_control/pi_control/pi_control.hpp"

double
    gate_hi_voltage = 6.0         ,
    gate_lo_voltage = -3.3        ,
    dt              = 150e-9      ,
    Ts              = 1.0/150.0e3 ,
    duty            = 0.5;

Modulator modulator1(Ts, duty, gate_hi_voltage, gate_lo_voltage, dt);
Modulator modulator2(Ts, duty, gate_hi_voltage, gate_lo_voltage, dt);

DeadtimeController deadtime(gate_hi_voltage, gate_lo_voltage, dt);

double 
    pwm = 0     ,
    t0  = 0     ,
    t1  = 0     ,
    vkp = 0.014 ,
    vki = 0.01;

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
   double &carrier  = data[3].d; // output
   double &vin      = data[4].d; // output
   double &carrier1 = data[5].d; // output
   double &gate3    = data[6].d; // output
   double &gate4    = data[7].d; // output
   double &vout     = data[8].d; // output
   double &iload    = data[9].d; // output
// Implement module evaluation code here:

    if (modulator2.synchronous_sample_called(t)) {
        double verror = 6.0-vdc;
        const double low_limit = -1;
        const double high_limit = 1;
        double piout = voltage_control.calculate_pi_out(verror, low_limit, high_limit);
        vout = piout;

    }
    if (modulator1.synchronous_sample_called(t)) {
        /* modulator1.set_frequency(175e3 - (70e3*vout)); */
        /* modulator1.set_phase((175e3 - (70e3*vout))*0.5); */
    }

    if (t > t0 + Ts/2){
        t0 = t;
        Ts = 1.0/(200e3 - (70e3*vout));

        if (pwm == 0) {
            pwm = 1;
        }
        else {
            pwm = 0;
        }
    }
    deadtime.update(t, pwm);

   vin = 400.0;
   modulator1.update(t);
   modulator2.update(t);
   carrier1 = modulator1.get_carrier();
   /* carrier2 = modulator2.get_carrier(); */
   gate1 = deadtime.getPWM_hi();
   gate2 = deadtime.getPWM_lo();
   gate3 = gate_lo_voltage;
   gate4 = gate_lo_voltage;
   iload = 0.0;

   // excitation 
   iload = 0; 
   if (t > 2.5e-3) iload = -8.5;
   if (t > 4.5e-3) iload = -12.0;
   if (t > 5.5e-3) iload = -3.0;
   if (t > 7.5e-3) iload = -1.0;
   /* if (t > 9.5e-3) iload = -1.0; */
}
