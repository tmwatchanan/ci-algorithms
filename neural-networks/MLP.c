#include <stdio.h>
#include <time.h>
#include <stdlib.h>
#include <math.h>

#define SIZE_OF(array) sizeof((array))/sizeof((array)[0])

#define NUM_INPUT_NODES 2
const int NUM_HIDDEN_NODES[] = {0};
#define NUM_OUTPUT_NODES 1
int NUM_HIDDEN_LAYERS = 0;
int NUM_LAYERS = 2; // 2 layers, input and output
int *NUM_NODES;

double UnitStep(double net);
#define ACTIVATION_FUNCTION(input) UnitStep((input))

int max(int a, const int* b, int c)
{
     int m = a;
     int size_b = sizeof(b) / sizeof(b[0]);
     for (int i = 0; i != size_b; ++i)
     {
         m = (m > b[i] ? m : b[i]);
     }
     m = (m > c ? m : c);
     return m;
}

const int MAX_NODES = max(NUM_INPUT_NODES, NUM_HIDDEN_NODES, NUM_OUTPUT_NODES);

// double weights[NUM_LAYERS][MAX_NODES][MAX_NODES];
// double **weights[NUM_LAYERS];
double ***weights;
double **outputs;

double RandomWeight()
{
    // [-1, 1]
    // double min = -1, max = 1;

    // [-1/sqrt(fanIn), 1/sqrt(fanIn)]
    double min = -1 / sqrt(NUM_INPUT_NODES), max = -min;

    double range = (max - min); 
    double div = RAND_MAX / range;
    return min + (rand() / div);
}

void InitializeWeights(double ***array)
{
    // 0,1,...,L-1
    int numLayers = NUM_LAYERS;
    // Initialize L layers
    array = (double ***) malloc (sizeof(double ***) * numLayers);

    // 1,...,L-1
    for (int l = 1; l <= NUM_LAYERS; ++l)
    {
        // Initialize nodes
        array[l] = (double **) malloc(sizeof(double*) * (NUM_NODES[l] + 1)); // +1 for bias
        for (int j = 0; j < NUM_NODES[l]; ++j)
        {
            array[l][j] = (double *) malloc(sizeof(double) * (NUM_NODES[l - 1] + 1)); // +1 for bias
            for (int i = 0 ; i < NUM_NODES[l - 1] + 1; ++i)
                if (l == 0) // Input vectors
                    array[l][j][i] = 1;
                else
                    array[l][j][i] = RandomWeight();
        }
    }
}

void InitializeOutputsAndBias(double **y, double *inputs, int inputs_size)
{

    // 0,1,...,L layers
    int numLayers = NUM_LAYERS + 1;
    // Initialize L + 1 layers
    y = (double **) malloc (sizeof(double **) * numLayers);

    // Input vectors
    printf("inputs_size = %d\n", inputs_size);
    y[0] = (double *) malloc(sizeof(double*) * inputs_size);
    for (int j = 0; j < inputs_size; ++j)
    {
        printf("inputs[%d] = %f\n", j, inputs[j]);
        y[0][j] = inputs[j];
    }

    // Initialize nodes
    int last_layer = SIZE_OF(NUM_NODES);
    for (int l = 0; l < last_layer; ++l)
    {
        // [Input & Hidden & Output] nodes
        y[l + 1] = (double *) malloc(sizeof(double*) * (NUM_NODES[l] + 1));
        y[l + 1][NUM_NODES[l]] = -1; // bias
    }

    for (int l = 0; l <= last_layer; ++l)
    {
        if (l == 0)
        {
            for (int j = 0; j < inputs_size; ++j)
            {
                printf("y[%d][%d] = %f\n", l, j, y[l][j]);
            }
        }
        else
        {
            for (int j = 0; j < NUM_NODES[l - 1]; ++j)
            {
                printf("y[%d][%d] = %f\n", l, j, y[l][j]);
            }
        }
    }

}

double Perceptron(double x[], double w[])
{
    double net = 0;
    for (int i = 0; i != NUM_INPUT_NODES; ++i)
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

void FeedForward(double *inputs, int inputs_size)
{
    for (int j = 0; j < inputs_size; ++j)
    {
        // outputs[0][j] = 
    }
    // for (int l = 1; l < NUM_LAYERS - 1; ++l)
    //     for (int j = 0; j < NUM_NODES[l]; ++j)
    //         for (int i = 0; i < NUM_NODES[l + 1]; ++i)
    //             if (j == 0 && i == 0)
}

int main()
{
    srand(time(NULL));

    for (int a = 0; a < SIZE_OF(NUM_HIDDEN_NODES); ++a)
    {
        if (NUM_HIDDEN_NODES[a] > 0)
            ++NUM_HIDDEN_LAYERS;
    }
    NUM_LAYERS += NUM_HIDDEN_LAYERS;

    NUM_NODES = (int *)malloc(sizeof(int)*NUM_LAYERS);
    NUM_NODES[0] = NUM_INPUT_NODES;
    for (int a = 1; a <= NUM_HIDDEN_LAYERS; ++a)
    {
        NUM_NODES[a] = NUM_HIDDEN_NODES[a];
    }
    NUM_NODES[NUM_LAYERS - 1] = NUM_OUTPUT_NODES;

    // for (int i = 0; i < SIZE_OF(NUM_NODES); ++i)
    // {
    //     printf("NUM_NODES[%d] = %d\n", i, NUM_NODES[i]);
    // }

    InitializeWeights(weights);
    int inputs_size = 2;
    double *inputs = (double *) malloc(inputs_size * sizeof(double));
    inputs[0] = 1;
    inputs[1] = 0;
    InitializeOutputsAndBias(outputs, inputs, inputs_size);
    for (int l = 0; l < NUM_LAYERS; ++l)
    {
        printf("NUM_NODES[%d] = %d\n", l, NUM_NODES[l]);
        for (int j = 0; j < NUM_NODES[l]; ++j)
        {
            printf("y[%d][%d] = %f\n", l, j, *(*(outputs + l) + j));
        }
    }

    double x[3] = {1, 1, 1};
    double w[3] = {1, 1, 1};
    printf("y = %f", Perceptron(x, w));

    return 0;
}