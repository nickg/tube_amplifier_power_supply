#ifndef MODULATOR_H
#define MODULATOR_H

#include <cmath>

#define deadtimelength 50e-9

class Modulator {
public:
    Modulator(double Ts, double duty, double gate_hi_voltage, double gate_lo_voltage, double deadtime);

    void update(double t);
    double getPWM() const;
    double getPWMLo() const;
    void set_duty(double set_duty_to);
    double calculate_carrier(double t);

/* private: */
    double Ts;
    double duty;
    double gate_hi_voltage;
    double gate_lo_voltage;
    double deadtime;
    double carrier;

    double previous_pwm;
    double PWM;
    double PWM_lo;
    double deadtime_start;
    double deadtime_stop;
};

#endif // MODULATOR_H

