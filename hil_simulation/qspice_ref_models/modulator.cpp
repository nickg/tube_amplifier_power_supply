#include "modulator.hpp"

Modulator::Modulator(double Ts, double duty, double gate_hi_voltage, double gate_lo_voltage, double deadtime)
    : Ts(Ts), duty(duty), gate_hi_voltage(gate_hi_voltage), gate_lo_voltage(gate_lo_voltage), deadtime(deadtime), interrupt_time(0.0),
      previous_pwm(0.0), PWM(gate_lo_voltage), PWM_lo(gate_hi_voltage), deadtime_start(0.0), deadtime_stop(0.0) { }


void Modulator::update(double t) {
    carrier = calculate_carrier(t);

    if (synchronous_sample_called(t)){
        interrupt_time = t + Ts;
    }

    if (duty > carrier) {
        PWM = gate_hi_voltage;
        PWM_lo = gate_lo_voltage;
    } else {
        PWM = gate_lo_voltage;
        PWM_lo = gate_hi_voltage;
    }

    if (previous_pwm != PWM) {
        deadtime_start = t;
        deadtime_stop = t + deadtime;
    }
    previous_pwm = PWM;

    if (t >= deadtime_start && t <= deadtime_stop) {
        PWM = gate_lo_voltage;
        PWM_lo = gate_lo_voltage;
    }
}

double Modulator::calculate_carrier(double t)
{
    return std::fabs((t / Ts - std::floor(t / Ts)) * 2.0 - 1.0);
}

double Modulator::getPWM() const {
    return PWM;
}

double Modulator::getPWMLo() const {
    return PWM_lo;
}

void Modulator::set_duty(double set_duty_to)
{
    duty = set_duty_to;
}

double Modulator::get_carrier() const
{
    return carrier;
}

bool Modulator::synchronous_sample_called(double t) const
{
    return (t > interrupt_time);
}

