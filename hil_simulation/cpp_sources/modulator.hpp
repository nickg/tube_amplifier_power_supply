#ifndef MODULATOR_H
#define MODULATOR_H
double calculate_carrier(double t, double Ts);

#include <cmath>

class DeadtimeController {
public:
    DeadtimeController(double gate_hi_voltage, double gate_lo_voltage, double deadtime);

    void update(double t, double pwm);
    double getPWM_hi() const;
    double getPWM_lo() const;

private:
    double gate_hi_voltage;
    double gate_lo_voltage;
    double deadtime;
    double previous_pwm;
    double PWM_hi;
    double PWM_lo;
    double deadtime_start;
    double deadtime_stop;

    void applyDeadtime(double t);
};


class Modulator {
public:
    Modulator(double Ts, double duty, double gate_hi_voltage, double gate_lo_voltage, double deadtime);

    void update(double t);
    void set_duty(double set_duty_to);
    bool synchronous_sample_called(double t) const;

    double getPWM() const;
    double getPWMLo() const;
    double get_carrier() const;

private:

    DeadtimeController deadtimecontrol;

    double Ts;
    double duty;
    double previous_duty;
    double gate_hi_voltage;
    double gate_lo_voltage;
    double deadtime;
    double carrier;
    double previous_carrier;
    double interrupt_time;

    double previous_pwm;
    double PWM;
    double PWM_lo;
    double deadtime_start;
    double deadtime_stop;

    int rising_edge_when_1;
    int previous_edge;
};

#endif // MODULATOR_H

