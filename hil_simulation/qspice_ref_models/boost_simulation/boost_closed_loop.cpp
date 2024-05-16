// Automatically generated C++ file on Thu May 16 20:22:23 2024
//
// To build with Digital Mars C++ Compiler:
//
//    dmc -mn -WD boost_closed_loop.cpp kernel32.lib

#include <cmath>
#include "modulator.hpp"

const double
    gate_hi_voltage = 6.0   ,
    gate_lo_voltage = -3.3  ,
    deadtime        = 50e-9 ,
    Ts              = 1.0/30.0e3 ;

double
    duty            = 0.5 ,
    iload           = 0   ,
    sampled_current = 0 ;

double
    i_error = 0.0,
    i_term = 0.0;

Modulator modulator(Ts, duty, gate_hi_voltage, gate_lo_voltage, deadtime);

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

// int DllMain() must exist and return 1 for a process to load the .DLL
// See https://docs.microsoft.com/en-us/windows/win32/dlls/dllmain for more information.
int __stdcall DllMain(void *module, unsigned int reason, void *reserved) { return 1; }

extern "C" __declspec(dllexport) void boost_closed_loop(void **opaque, double t, union uData *data)
{
   double l1_current       = data[0].d; // input
   double l2_current       = data[1].d; // input
   double uout             = data[2].d; // input
   double &PWM             = data[3].d; // output
   double &PWM_lo          = data[4].d; // output
   double &carrier         = data[5].d; // output
   double &iload           = data[6].d; // output
   double &sampled_current = data[7].d; // output
   double &vin             = data[8].d; // output

    if (modulator.synchronous_sample_called(t))  // rising_edge of clock
    {
        sampled_current = -1000.0*(l1_current - l2_current);
        i_error = 4.0 - sampled_current;
        double duty = vin/uout + i_error * 0.06 + i_term;
        i_term = i_term + i_error * 0.03;
        if (duty > 0.9){
            duty = 0.9;
            /* i_term = 0.9 - i_error*0.1; */
        }
        else if (duty < 0.1) {
            duty = 0.1;
            /* i_term = 0.1-i_error*0.1; */
        }
        modulator.set_duty(1-duty);

        carrier = i_error;
    }

    modulator.update(t);
    PWM     = modulator.getPWM();
    PWM_lo  = modulator.getPWMLo();

    // model excitement
    if (t > 30.0e-3)
    {
        iload = 2.0;
    } else {
        iload = -2.0;
    }

    if (t > 40.0e-3)
        vin = 150.0;
    else
        vin = 100.0;

}
