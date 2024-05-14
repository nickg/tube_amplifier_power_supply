// Automatically generated C++ file on Mon Feb  5 19:35:36 2024
//
// To build with Digital Mars C++ Compiler:
//
//    dmc -mn -WD dpwmcl.cpp kernel32.lib

#include <cmath>

const double
    gate_hi_voltage = 15.0   ,
    gate_lo_voltage = -3.3   ,
    deadtime        = 200e-9 ,
    Ts              = 1.0/50.0e3; //

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
   double &PWM             = data[1].d; // output
   double &PWM_lo          = data[2].d; // output
   double &carrier         = data[3].d; // output
   double &iload           = data[4].d; // output
   double l1_current       = data[5].d; // input
   double &sampled_current = data[6].d; // output

    if ((CLK>0.999)&&(CLK<=1.001))  // rising_edge of clock
    {
        duty = 0.25;
        sampled_current = l1_current;
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

    if (t > 3.0e-3)
    {
        iload = -1.0;
    } else {
        iload = 0;
    }
}
