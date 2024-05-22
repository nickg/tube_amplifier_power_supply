// Automatically generated C++ file on Wed May 22 07:30:52 2024
//
// To build with Digital Mars C++ Compiler: 
//
//    dmc -mn -WD pfc.cpp kernel32.lib

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
#undef PFCPWM_hi
#undef PFCPWM_lo
#undef sampled_current
#undef vin
#undef PFC_load

extern "C" __declspec(dllexport) void pfc(void **opaque, double t, union uData *data)
{
   double  l1_current      = data[0].d; // input
   double  l2_current      = data[1].d; // input
   double  dclink          = data[2].d; // input
   double &PFCPWM_hi       = data[3].d; // output
   double &PFCPWM_lo       = data[4].d; // output
   double &sampled_current = data[5].d; // output
   double &vin             = data[6].d; // output
   double &PFC_load        = data[7].d; // output

// Implement module evaluation code here:

}
