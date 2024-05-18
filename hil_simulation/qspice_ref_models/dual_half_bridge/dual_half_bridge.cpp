// Automatically generated C++ file on Sat May 18 10:58:14 2024
//
// To build with Digital Mars C++ Compiler:
//
//    dmc -mn -WD dual_half_bridge.cpp kernel32.lib

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
#undef gate1
#undef gate2
#undef carrier2
#undef vin
#undef carrier1
#undef gate3
#undef gate4
#undef vout
#undef vdc

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

}
