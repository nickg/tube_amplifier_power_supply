#ifndef VOLTAGECONTROLLER_H
#define VOLTAGECONTROLLER_H

class VoltageController {
public:
    VoltageController(double vkp = 1.0/4.0, double vki = 1.0/128.0, double upper_limit = 7.0, double lower_limit = -7.0);

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

