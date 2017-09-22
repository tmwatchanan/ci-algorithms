#include <stdio.h>
#include <time.h>
#include <stdlib.h>
#include <math.h>

#define SIZE_OF(array) sizeof((array))/sizeof((array)[0])

int NUM_INPUT_NODES;
const int NUM_HIDDEN_NODES[] = {2};
int NUM_OUTPUT_NODES;
int NUM_HIDDEN_LAYERS = 0;
int NUM_LAYERS = 2; // 2 layers, input layer and output layer
int *NUM_NODES;
int OUTPUT_LAYER;

#define BIAS_VALUE 1

double UnitStep(double net);
double Sigmoid(double v);
double DerivativeSigmoid(double v);
#define ACTIVATION_FUNCTION(input) UnitStep((input))
#define DERIVATIVE_FUNCTION(input) DerivativeSigmoid((input))

double ***weights;
double ***weights_old;
double **nets;
double **outputs;
double *errors;
double AverageError;
double **local_gradients;

#define LEARNING_RATE 0.6

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
    for (int l = 1; l < NUM_LAYERS; ++l)
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


double** InitializeNets(double **nets)
{
    // Initialize L + 1 layers (0,1,...,L-1)
    nets = (double **) malloc (sizeof(double **) * NUM_LAYERS);

    for (int l = 1; l < NUM_LAYERS; ++l)
    {
        int numNodes = (l != OUTPUT_LAYER ? NUM_NODES[l] : NUM_OUTPUT_NODES);
        nets[l] = (double *) malloc(sizeof(double *) * numNodes);
    }
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

double* InitializeErrors(int num_nodes)
{
    double* errors = (double *) malloc (sizeof(double) * num_nodes);
    return errors;
}

double Perceptron(double *x, double *w, int layer, int node)
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
    // nets[layer][node] = net;
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

double Sigmoid(double v)
{
    return 1 / (1 + exp(-v));
}

double DerivativeSigmoid(double v)
{
    return v * (1 - v);
}

double* FeedForward(double *inputs, int inputs_size, double* desired_outputs, double* errors)
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


    // for (int l = 1; l < NUM_LAYERS; ++l)
    // {
    //     for (int j = 0; j < NUM_NODES[l] - 1; ++j)
    //     {
    //         for (int i = 0; i < NUM_NODES[l - 1]; ++i) // also bias
    //         {
    //             printf("weights[%d][%d][%d] = %f\n", l, j, i, weights[l][j][i]);
    //         }
    //     }
    // }
    for (int l = 1; l < NUM_LAYERS; ++l)
    {
        printf("NUM_NODES[%d] - 1 = %d\n", l, NUM_NODES[l] - 1);
        for (int j = 0; j < NUM_NODES[l] - 1; ++j)
        {
            outputs[l][j] = Perceptron(outputs[l - 1], weights[l][j], l - 1, j);
        }
    }

    AverageError = 0;
    for (int j = 0; j < NUM_OUTPUT_NODES; ++j)
    {
        printf("errors[%d] = %f\n", j, errors[j]);
        printf("outputs[%d][%d] = %f\n", OUTPUT_LAYER, j, outputs[OUTPUT_LAYER][j]);
        printf("desired_outputs[%d] = %f\n", j, desired_outputs[j]);
        errors[j] = outputs[OUTPUT_LAYER][j] - desired_outputs[j];
        AverageError += errors[j] * errors[j];
        printf("errors[%d] = %f\n", j, errors[j]);
    }
    AverageError /= 2;

    return errors;
}

double** InitializeLocalGradients(double **local_gradients)
{
    // Initialize L + 1 layers (0,1,...,L-1)
    local_gradients = (double **) malloc (sizeof(double **) * NUM_LAYERS);

    for (int l = 1; l < NUM_LAYERS; ++l)
    {
        int numNodes = (l != OUTPUT_LAYER ? NUM_NODES[l] : NUM_OUTPUT_NODES);
        local_gradients[l] = (double *) malloc(sizeof(double *) * numNodes);
    }
    return local_gradients;
}

void BackPropagation()
{
    // Local gradient at output layer
    for (int j = 0; j < NUM_OUTPUT_NODES; ++j)
    {
        local_gradients[OUTPUT_LAYER][j] = errors[j] * DerivativeSigmoid(nets[OUTPUT_LAYER][j]);
    }
    // Local gradient at hidden layers
    for (int l = OUTPUT_LAYER - 1; l > 0; ++l)
    {
        for (int j = 0; j < NUM_NODES[l]; ++j)
        {
            int numNodes = (l + 1 == OUTPUT_LAYER ? NUM_NODES[l + 1] + 1 : NUM_NODES[l + 1]);
            double sum_gradients = 0;
            for (int k = 0; k < numNodes; ++k)
            {
                sum_gradients += (local_gradients[l + 1][k] * weights[l + 1][k][j]);
            }
            local_gradients[l][j] = LEARNING_RATE * DerivativeSigmoid(nets[l][j]) * sum_gradients;
        }
    }
}

int main()
{
    srand(time(NULL));

    int inputs_size = 2;
    double *inputs = (double *) malloc(inputs_size * sizeof(double));
    inputs[0] = 1;
    inputs[1] = 1;

    int outputs_size = 1;
    double *desired_outputs = (double *) malloc(sizeof(double) * outputs_size);
    desired_outputs[0] = 0;

    // Number of layers
    for (int a = 0; a < SIZE_OF(NUM_HIDDEN_NODES); ++a)
    {
        if (NUM_HIDDEN_NODES[a] > 0)
            ++NUM_HIDDEN_LAYERS;
    }
    NUM_LAYERS += NUM_HIDDEN_LAYERS;
    OUTPUT_LAYER = NUM_LAYERS - 1;

    // Number of nodes
    NUM_NODES = (int *)malloc(sizeof(int)*NUM_LAYERS + 1);
    NUM_NODES[0] = inputs_size + 1; // +1 for bias
    NUM_INPUT_NODES = NUM_NODES[0] - 1;
    for (int a = 0; a < NUM_HIDDEN_LAYERS; ++a)
    {
        NUM_NODES[a + 1] = NUM_HIDDEN_NODES[a] + 1; // +1 for bias
    }
    NUM_NODES[OUTPUT_LAYER] = outputs_size + 1;
    NUM_OUTPUT_NODES = outputs_size; //NUM_NODES[OUTPUT_LAYER] - 1

    weights_old = InitializeWeights(weights_old);
    weights = InitializeWeights(weights);
    nets = InitializeNets(nets);
    outputs = InitializeOutputsAndBias(outputs, inputs, inputs_size);
    errors = InitializeErrors(NUM_OUTPUT_NODES);
    local_gradients = InitializeLocalGradients(local_gradients);

    printf("-------------------\n");

    errors = FeedForward(inputs, inputs_size, desired_outputs, errors);

    return 0;
}
