#ifndef VOLTAGECONTROLLER_H
#define VOLTAGECONTROLLER_H

class VoltageController {
public:
    VoltageController(double vkp = 0.3 * 0.9, double vki = 0.3 * 0.025, double upper_limit = 7.0, double lower_limit = -7.0);

    double compute(double v_error);

private:
    double vkp;
    double vki;
    double upper_limit;
    double lower_limit;
    double i_term;

    double sgn(double input);
};

#endif // VOLTAGECONTROLLER_H

