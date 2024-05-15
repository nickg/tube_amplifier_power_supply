// Automatically generated C++ file on Mon Feb  5 19:35:36 2024
//
// To build with Digital Mars C++ Compiler:
//
//    dmc -mn -WD dpwmcl.cpp kernel32.lib

// compiled with gcc in widows
// gcc -c -o dpwm.o dpwm.cpp & gcc -o dpwm.dll -s -shared dpwm.o -Wl,--subsystem,windows
#include <cmath>
#include "constants.hpp"

const double
    gate_hi_voltage = 6.0    ,
    gate_lo_voltage = -3.3   ,
    deadtime        = deadtimelength ,
    Ts              = 1.0/30.0e3; //

double
    deadtime_start = 0 ,
    deadtime_stop  = 0 ,
    previous_pwm   = 0 ,
    duty           = 0 ,
    iload          = 0 ,
    sampled_current = 0
    ;

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

extern "C" __declspec(dllexport) void dpwm(void **opaque, double t, union uData *data)
{
   double  CLK             = data[0].d; // input
   double l1_current       = data[1].d; // input
   double l2_current       = data[2].d; // input
   double &PWM             = data[3].d; // output
   double &PWM_lo          = data[4].d; // output
   double &carrier         = data[5].d; // output
   double &iload           = data[6].d; // output
   double &sampled_current = data[7].d; // output
   double &vin             = data[8].d; // output

    if ((CLK>0.999)&&(CLK<=1.001))  // rising_edge of clock
    {

        sampled_current = -1000.0*(l1_current - l2_current);
    }

    // modulator
        carrier = fabs((t/Ts - floor(t/Ts))*2.0 - 1.0);

        if (duty>carrier)
        {
            PWM    = gate_hi_voltage;
            PWM_lo = gate_lo_voltage;
        }
        else
        {
            PWM    = gate_lo_voltage;
            PWM_lo = gate_hi_voltage;
        }

        if (previous_pwm != PWM)
        {
            deadtime_start = t;
            deadtime_stop  = t + deadtime;
        }
        previous_pwm = PWM;

        if (t >= deadtime_start && t <= deadtime_stop) {
            PWM    = gate_lo_voltage;
            PWM_lo = gate_lo_voltage;
        }
    // modulator - end

    // model excitement
    if (t > 6.0e-3)
    {
        iload = -0.0;
    } else {
        iload = 0;
    }

    if (t > 40.0e-3)
        vin = 120.0;
    else
        vin = 100.0;

    if (t > 15e-3)
        duty = 0.25;
    else
        duty = 0.5;
    // model excitement end

}
