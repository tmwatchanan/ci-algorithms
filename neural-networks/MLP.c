#include <stdio.h>

#define NUM_INPUT 2

double UnitStep(double net);

#define ACTIVATION_FUNCTION(input) UnitStep((input))
#define ARRAY_LENGTH(array) sizeof((array)) / sizeof((array)[0])

double Perceptron(double x[], double w[])
{
    double net = 0;
    for (int i = 0; i != NUM_INPUT; ++i)
    {
        net += x[i] * w[i];
    }
    return ACTIVATION_FUNCTION(net);
}

double UnitStep(double net)
{
    if (net > 0) return 1;
    else if (net == 0) return net / 2;
    else return -1;
    // return (net > 0 ? 1 : -1);
}

int main()
{
    double x[2] = {1, 1};
    double w[2] = {1, 1};
    printf("y = %f", Perceptron(x, w));

    return 0;
}