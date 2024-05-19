#include "pi_control.hpp"

PIController::PIController(double kp, double ki, double pi_limit)
    : kp(kp), ki(ki), i_term(0.0), pi_limit(pi_limit) {}

double PIController::calculate_pi_out(double error, double lower_limit, double upper_limit) {
    const double k_term = error * kp;
    double pi_out = k_term + i_term;
    if (pi_out < lower_limit) {
        i_term -= sgn(pi_out - lower_limit) * 0.1;
        pi_out = lower_limit;
    } else if (pi_out > upper_limit) {
        i_term += sgn(pi_out - upper_limit) * 0.1;
        pi_out = upper_limit;
    } else {
        i_term += error * ki;
    }
    if (std::fabs(pi_out) > pi_limit) {
        pi_out = sgn(pi_out) * pi_limit;
    }

    return pi_out;
}

double PIController::sgn(double input) {
    return (input < 0.0) ? -1.0 : 1.0;
}

