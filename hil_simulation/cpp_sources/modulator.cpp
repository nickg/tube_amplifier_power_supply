#include "modulator.hpp"
double calculate_carrier(double t, double Ts)
{
    const double offset = Ts/0.5;
    return std::fabs(((t + offset) / Ts - std::floor((t+ offset) / Ts )) * 2.0 - 1.0);
}

Modulator::Modulator(double Ts, double duty, double gate_hi_voltage, double gate_lo_voltage, double deadtime)
    : deadtimecontrol(gate_hi_voltage, gate_lo_voltage, deadtime), Ts(Ts), duty(duty), previous_duty(0.0), carrier(0.0), previous_carrier(0.0), interrupt_time(0.0),
      rising_edge_when_1(0), previous_edge(0) { }


void Modulator::update(double t) {

    if (synchronous_sample_called(t)){
        interrupt_time = t + Ts;
    }
    previous_carrier = carrier;
    carrier = calculate_carrier(t, Ts);
    previous_edge = rising_edge_when_1;
    if (previous_carrier > carrier) {
        rising_edge_when_1 = 1.0;
    }else
        rising_edge_when_1 = 0.0;

    if (duty > carrier) {
        PWM = 1.0;
    } else {
        PWM = 0.0;
    }
    deadtimecontrol.update(t, PWM);
}


void Modulator::set_duty(double set_duty_to)
{
    previous_duty = duty;
    duty = set_duty_to;
}


double Modulator::getPWM() const {
    return deadtimecontrol.getPWM_hi();
}

double Modulator::getPWMLo() const {
    return deadtimecontrol.getPWM_lo();
}

double Modulator::get_carrier() const
{
    return carrier;
}

bool Modulator::synchronous_sample_called(double t) const
{
    return (rising_edge_when_1 != previous_edge);
}
 // ---------------------------- deadtime implementation --------------------
 //
DeadtimeController::DeadtimeController(double gate_hi_voltage, double gate_lo_voltage, double deadtime)
    : gate_hi_voltage(gate_hi_voltage), gate_lo_voltage(gate_lo_voltage), deadtime(deadtime),
      previous_pwm(gate_lo_voltage), PWM_hi(gate_lo_voltage), PWM_lo(gate_hi_voltage),
      deadtime_start(0.0), deadtime_stop(0.0) {}

void DeadtimeController::update(double t, double pwm) {
    if (pwm > 0) {
        PWM_hi = gate_hi_voltage;
        PWM_lo = gate_lo_voltage;
    } else {
        PWM_hi = gate_lo_voltage;
        PWM_lo = gate_hi_voltage;
    }

    if (previous_pwm != pwm) {
        deadtime_start = t;
        deadtime_stop = t + deadtime;
    }
    previous_pwm = pwm;

    applyDeadtime(t);
}

void DeadtimeController::applyDeadtime(double t) {
    if (t >= deadtime_start && t <= deadtime_stop) {
        PWM_hi = gate_lo_voltage;
        PWM_lo = gate_lo_voltage;
    }
}

double DeadtimeController::getPWM_hi() const {
    return PWM_hi;
}

double DeadtimeController::getPWM_lo() const {
    return PWM_lo;
}

