// Automatically generated C++ file on Thu May 16 20:22:23 2024
//
// To build with Digital Mars C++ Compiler:
//
//    dmc -mn -WD boost_closed_loop.cpp kernel32.lib

#include <cmath>

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
    i_term = 0.0,
    prev_sample_trigger = 0.0,
    sampletime = 0.0;

int rising_edge_when_1 = 0;
int previous_edge = 0;

#include "../../cpp_sources/modulator.hpp"
Modulator modulator(Ts, duty, gate_hi_voltage, gate_lo_voltage, deadtime);
#include "../../cpp_sources/feedback_control/current_control.hpp"

const
    double ikp = 16.0;
    double iki = 8.0;
    double min_duty = 0.1;
    double max_duty = 0.9;
CurrentController current_control(ikp, iki, min_duty, max_duty);

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

double calculate_carrier(double t, double Ts, double phase_plusminus_half)
{
    const double phase = Ts*phase_plusminus_half;
    return std::fabs(((t + phase) / Ts - std::floor((t+ phase) / Ts )) * 2.0 - 1.0);
}

// int DllMain() must exist and return 1 for a process to load the .DLL
// See https://docs.microsoft.com/en-us/windows/win32/dlls/dllmain for more information.
int __stdcall DllMain(void *module, unsigned int reason, void *reserved) { return 1; }

double sgn(double input){
    double retval = 1.0;
    if (input < 0.0) retval = -1.0;
    return retval;
}

extern "C" __declspec(dllexport) void boost_voltage_closed_loop(void **opaque, double t, union uData *data)
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
   double &sample_trigger  = data[9].d; // output

    if (modulator.synchronous_sample_called(t))  // rising_edge_when_1 of clock
    {

        double vref = 200.0;
        if (t > 50.0e-3) vref = 150.0;
        double v_error = vref - uout;


        const double vkp = 0.3* 0.9;
        const double vki = 0.3 * 0.05;
        const double vk_term = v_error * vkp;
        double iref = vk_term + i_term;
        i_term = i_term + v_error * vki;

        /* const double upper_limit = vin-min_duty*uout; */
        /* const double lower_limit = vin-max_duty*uout; */
        /* if (uL < lower_limit) { */
        /*     i_term = i_term - sgn(uL - lower_limit)*0.1; */
        /*     uL = lower_limit; */
        /* }else if(uL > upper_limit){ */
        /*     i_term = i_term + sgn(uL - upper_limit)*0.1; */
        /*     uL = upper_limit; */
        /* }else{ */
        /* } */
        /* if (fabs(uL) > 31.0) */
        /*     uL = sgn(uL)*31.0; */

        const double shunt_res = 0.001;
        sampled_current = (l2_current - l1_current)/shunt_res;

        double voltage_over_inductor = current_control.compute(iref, sampled_current, vin, uout);

        double duty = (vin - voltage_over_inductor)/uout;
        modulator.set_duty(duty);

    }
    double prev_carrier = carrier;
    carrier = calculate_carrier(t, Ts, 0.5);
    previous_edge = rising_edge_when_1;
    if (prev_carrier > carrier) {
        rising_edge_when_1 = 1.0;
    }else
        rising_edge_when_1 = 0.0;

    if (previous_edge != rising_edge_when_1)
        sample_trigger = 1.0;
    else
        sample_trigger = 0.0;



    modulator.update(t);
    PWM     = modulator.getPWM();
    PWM_lo  = modulator.getPWMLo();

    // model excitement
    if (t > 40.0e-3)
    {
        iload = 2.0;
    } else {
        iload = 0.0;
    }

    if (t > 00.0e-3) vin = 100.0;
    if (t > 40.0e-3) vin = 130.0;
    /* if (t > 35.0e-3) vin = 10.0; */

}
