#ifndef MODULATOR_H
#define MODULATOR_H

#include <cmath>

class Modulator {
public:
    Modulator(double Ts, double duty, double gate_hi_voltage, double gate_lo_voltage, double deadtime);

    void update(double t);
    void set_duty(double set_duty_to);
    double calculate_carrier(double t) const;
    bool synchronous_sample_called(double t) const;

    double getPWM() const;
    double getPWMLo() const;
    double get_carrier() const;

private:
    double Ts;
    double duty;
    double gate_hi_voltage;
    double gate_lo_voltage;
    double deadtime;
    double carrier;
    double interrupt_time;

    double previous_pwm;
    double PWM;
    double PWM_lo;
    double deadtime_start;
    double deadtime_stop;
};

#endif // MODULATOR_H

