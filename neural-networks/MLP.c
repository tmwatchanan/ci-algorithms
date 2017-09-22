#include <stdio.h>
#include <time.h>
#include <stdlib.h>
#include <math.h>

#define SIZE_OF(array) sizeof((array))/sizeof((array)[0])

#define NUM_INPUT_NODES 2
const int NUM_HIDDEN_NODES[] = {2};
#define NUM_OUTPUT_NODES 1
int NUM_HIDDEN_LAYERS = 0;
int NUM_LAYERS = 2; // 2 layers, input layer and output layer
int *NUM_NODES;

#define BIAS_VALUE 1

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

double*** InitializeWeights(double ***array)
{
    // Initialize L layers (0,1,...,L-1)
    array = (double ***) malloc (sizeof(double ***) * NUM_LAYERS);

    // Hidden Layers
    for (int l = 1; l < NUM_LAYERS - 1; ++l)
    {
        // Initialize nodes
        array[l] = (double **) malloc(sizeof(double*) * (NUM_NODES[l] - 1));
        for (int j = 0; j < NUM_NODES[l] - 1; ++j)
        {
            array[l][j] = (double *) malloc(sizeof(double) * (NUM_NODES[l - 1])); // +1 for bias
            // 0,1,...,N-1, N <-- bias
            for (int i = 0 ; i < NUM_NODES[l - 1]; ++i)
                array[l][j][i] = RandomWeight();
        }
    }

    int OUTPUT_LAYER = NUM_LAYERS - 1;
    array[OUTPUT_LAYER] = (double **) malloc(sizeof(double*) * (NUM_NODES[OUTPUT_LAYER]));
    for (int j = 0; j < NUM_NODES[OUTPUT_LAYER]; ++j)
    {
        array[OUTPUT_LAYER][j] = (double *) malloc(sizeof(double) * (NUM_NODES[OUTPUT_LAYER - 1])); // +1 for bias
        // 0,1,...,N-1, N <-- bias
        for (int i = 0 ; i < NUM_NODES[OUTPUT_LAYER - 1]; ++i)
            array[OUTPUT_LAYER][j][i] = RandomWeight();
    }

    for (int l = 1; l < NUM_LAYERS; ++l)
    {
        for (int j = 0; j < NUM_NODES[l] - 1; ++j)
        {
            for (int i = 0; i < NUM_NODES[l - 1]; ++i) // also bias
            {
                printf("weights[%d][%d][%d] = %f\n", l, j, i, array[l][j][i]);
            }
        }
    }
    return array;
}

double** InitializeOutputsAndBias(double **y, double *inputs, int inputs_size)
{
    // Initialize L + 1 layers (0,1,...,L-1)
    y = (double **) malloc (sizeof(double **) * NUM_LAYERS);

    for (int l = 0; l < NUM_LAYERS; ++l)
    {
        y[l] = (double *) malloc(sizeof(double *) * NUM_NODES[l]);
        y[l][NUM_NODES[l] - 1] = BIAS_VALUE;
    }
    
    for (int j = 0; j < inputs_size; ++j)
    {
        y[0][j] = inputs[j];
    }

    for (int l = 0; l < NUM_LAYERS; ++l)
    {
        for (int j = 0; j < NUM_NODES[l]; ++j)
        {
            printf("y[%d][%d] = %f\n", l, j, y[l][j]);
        }
    }
    return y;
}

double Perceptron(double *x, double *w, int layer)
{
    // for (int i = 0; i < 2; ++i)
    // {
    //     printf("x[%d] = %f\n", i, x[i]);
    // }
    double net = 0;
    for (int i = 0; i < NUM_NODES[layer]; ++i)
    {
        printf("%f x %f = %f\n", x[i], w[i], x[i] * w[i]);
        net += x[i] * w[i];
    }
    printf("net = %f | outputs = %f\n", net, ACTIVATION_FUNCTION(net));
    return ACTIVATION_FUNCTION(net);
}

double UnitStep(double net)
{
    if (net > 0) return 1;
    else if (net == 0) return net / 2;
    else return 0;
    // return (net > 0 ? 1 : -1);
}

void FeedForward(double *inputs, int inputs_size)
{
    weights[1][0][0] = 1;
    weights[1][0][1] = 1;
    weights[1][0][2] = -1.5;
    weights[1][1][0] = 1;
    weights[1][1][1] = 1;
    weights[1][1][2] = -0.5;
    weights[2][0][0] = -2;
    weights[2][0][1] = 1;
    weights[2][0][2] = -0.5;


    for (int l = 1; l < NUM_LAYERS; ++l)
    {
        for (int j = 0; j < NUM_NODES[l] - 1; ++j)
        {
            for (int i = 0; i < NUM_NODES[l - 1]; ++i) // also bias
            {
                printf("weights[%d][%d][%d] = %f\n", l, j, i, weights[l][j][i]);
            }
        }
    }
    for (int l = 1; l < NUM_LAYERS; ++l)
    {
        for (int j = 0; j < NUM_NODES[l] - 1; ++j)
        {
            outputs[l][j] = Perceptron(outputs[l - 1], weights[l][j], l - 1);
            if (l == 2 && j == 0)
            {
                printf("outputs[%d][%d] = %f\n", l, j, outputs[l][j]);
            }
        }
    }
}

int main()
{
    srand(time(NULL));

    int inputs_size = 2;
    double *inputs = (double *) malloc(inputs_size * sizeof(double));
    inputs[0] = 0;
    inputs[1] = 0;

    for (int a = 0; a < SIZE_OF(NUM_HIDDEN_NODES); ++a)
    {
        if (NUM_HIDDEN_NODES[a] > 0)
            ++NUM_HIDDEN_LAYERS;
    }
    NUM_LAYERS += NUM_HIDDEN_LAYERS;

    NUM_NODES = (int *)malloc(sizeof(int)*NUM_LAYERS + 1);
    NUM_NODES[0] = inputs_size + 1; // +1 for bias
    for (int a = 0; a < NUM_HIDDEN_LAYERS; ++a)
    {
        NUM_NODES[a + 1] = NUM_HIDDEN_NODES[a] + 1; // +1 for bias
    }
    NUM_NODES[NUM_LAYERS - 1] = NUM_OUTPUT_NODES + 1;

    weights = InitializeWeights(weights);
    outputs = InitializeOutputsAndBias(outputs, inputs, inputs_size);

    printf("-------------------\n");

    FeedForward(inputs, inputs_size);

    return 0;
}