// Automatically generated C++ file on Tue May 21 06:39:37 2024
//
// To build with Digital Mars C++ Compiler:
//
//    dmc -mn -WD guitar_power_supply.cpp kernel32.lib

// use constants from cmath library
#define _USE_MATH_DEFINES
#include <cmath>

const double
    gate_hi_voltage = 6.0   ,
    gate_lo_voltage = -3.3  ,
    deadtime        = 50e-9 ,
    Ts              = 1.0/135.0e3 ;

double
    duty                = 0.5 ,
    iload               = 0   ,
    sampled_current     = 0   ,
    i_term              = 0.0 ,
    prev_sample_trigger = 0.0 ,
    sampletime          = 0.0, 
    iref = 0.0,
    vref = 200.0;

#include "../../cpp_sources/modulator/modulator.hpp"
Modulator pfc_modulator(Ts, duty, gate_hi_voltage, gate_lo_voltage, deadtime);

const
    double ikp = 64.0;
    double iki = 8.0;
    double min_duty = 0.1;
    double max_duty = 0.9;

#include "../../cpp_sources/feedback_control/current_control.hpp"
CurrentController current_control(ikp, iki, min_duty, max_duty);

double 
    pfc_vkp     = 0.005*1.0/4.0   ,
    pfc_vki     = 0.005*1.0/128.0 ,
    upper_limit = 7.0       ,
    lower_limit = 0      ;

#include "../../cpp_sources/feedback_control/voltage_control.hpp"
VoltageController voltage_control(pfc_vkp, pfc_vki, upper_limit, lower_limit);
// dhb 
//
#include "../../cpp_sources/feedback_control/pi_control/pi_control.hpp"

const double
    dhb_deadtime        = 50e-9 ,
    dhb_Ts              = 1.0/100.0e3 ,
    dhb_duty            = 0.5;

Modulator modulator1(dhb_Ts, dhb_duty, gate_hi_voltage, gate_lo_voltage, dhb_deadtime);
Modulator modulator2(dhb_Ts, dhb_duty, gate_hi_voltage, gate_lo_voltage, dhb_deadtime);

const double 
    vkp = 0.15,
    vki = 0.01;

pi_control dhb_voltage_control(vkp, vki, 1.0);

// QSPICE datatype
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

// #undef pin names lest they collide with names in any header file(s) you might include.
#undef l1_current
#undef l2_current
#undef dclink
#undef vdc_dhb
#undef vout_llc
#undef PFCPWM_hi
#undef PFCPWM_lo
#undef dhb_pwmhi1
#undef dhb_pwmlo1
#undef dhb_pwmhi2
#undef dhb_pwmlo2
#undef sampled_current
#undef vin
#undef dhb_load
#undef PFC_load

extern "C" __declspec(dllexport) void guitar_power_supply(void **opaque, double t, union uData *data)
{
   double  l1_current      = data[ 0].d; // input
   double  l2_current      = data[ 1].d; // input
   double  dclink          = data[ 2].d; // input
   double  vdc_dhb         = data[ 3].d; // input
   double  vout_llc        = data[ 4].d; // input
   double &PFCPWM_hi       = data[5].d; // output
   double &PFCPWM_lo       = data[6].d; // output
   double &dhb_pwmhi1      = data[7].d; // output
   double &dhb_pwmlo1      = data[8].d; // output
   double &dhb_pwmhi2      = data[9].d; // output
   double &dhb_pwmlo2      = data[10].d; // output
   double &sampled_current = data[11].d; // output
   double &vin             = data[12].d; // output
   double &dhb_load        = data[13].d; // output
   double &iref        = data[14].d; // output

// Implement module evaluation code here:

    if (pfc_modulator.synchronous_sample_called(t))
    {
        double v_error = 400 - dclink;

        iref = voltage_control.compute(v_error);
        iref = iref*vin/230;

        const double shunt_res = 0.001;
        sampled_current = (l2_current - l1_current)/shunt_res;

        double voltage_over_inductor = current_control.compute(iref, sampled_current, vin, dclink);

        double duty = (vin - voltage_over_inductor)/dclink;
        pfc_modulator.set_duty(duty);

    }

    pfc_modulator.update(t);
    PFCPWM_hi = pfc_modulator.getPWM();
    PFCPWM_lo = pfc_modulator.getPWMLo();

    if (modulator2.synchronous_sample_called(t))
    {
        double verror = 400-vdc_dhb;
        const double low_limit = -0.2;
        const double high_limit = 0.2;
        double piout = dhb_voltage_control.calculate_pi_out(verror, low_limit, high_limit);
        modulator1.set_phase(piout);
    }

   modulator1.update(t);
   modulator2.update(t);
   dhb_pwmhi1 = modulator1.getPWM();
   dhb_pwmlo1 = modulator1.getPWMLo();
   dhb_pwmhi2 = modulator2.getPWM();
   dhb_pwmlo2 = modulator2.getPWMLo();

    // model excitement
    if (t > 00.0e-3) vin      = 325*fabs(sin(t*2*M_PI*50));
    if (t > 30.0e-3) dhb_load = -1.0;
    /* if (t > 30.0e-3) vref     = 120.0; */
    /* if (t > 40.0e-3) vin      = 130.0; */
    /* if (t > 50.0e-3) vref     = 180.0; */
    /* if (t > 65.0e-3) PFC_load = 10.0; */
    /* if (t > 70.0e-3) PFC_load = -10.0; */
    /* if (t > 80.0e-3) PFC_load = 0.0; */

    /* dhb_load = 0; */
}
