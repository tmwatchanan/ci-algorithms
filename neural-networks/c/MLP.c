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

#define BIAS_VALUE -1

double UnitStep(double net);
double Sigmoid(double v);
double DerivativeSigmoid(double v);
double HyperbolicTangent(double v);
double DerivativeHyperbolicTangent(double y);
#define ACTIVATION_FUNCTION(input) HyperbolicTangent((input))
#define DERIVATIVE_FUNCTION(input) DerivativeHyperbolicTangent((input))

double ***weights;
double ***weights_old;
double ***delta_weights;
double **nets;
double **outputs;
double *errors;
double AverageError = 0;
double **local_gradients;

static const char dataFileName[] = "xor.pat";
int NUM_INPUT_SAMPLES = 0;
int NUM_INPUT_FEATURES = 2;
int NUM_OUTPUT_CLASSES = 1;
double **DataInputs;
double **DataOutputs;

int epoch = 1;
#define EPSILON_ERROR 0.1
#define LEARNING_RATE 0.2
#define MOMEMTUM_RATE 0.1

double RandomWeight(int fanIn)
{
    // [-1, 1]
    // double min = -1, max = 1;

    // [-1/sqrt(fanIn), 1/sqrt(fanIn)]
    double min = -1 / sqrt(fanIn), max = -min;

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
                array[l][j][i] = RandomWeight(NUM_NODES[l - 1]);
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
        // printf("NUM_NODES[%d] - 1 = %d\n", NUM_NODES[l], NUM_NODES[l] - 1);
        nets[l] = (double *) malloc(sizeof(double *) * NUM_NODES[l] - 1);
    }
    return nets;
}

double** InitializeOutputsAndBias(double **y, double *inputs)
{
    // Initialize L + 1 layers (0,1,...,L-1)
    y = (double **) malloc (sizeof(double **) * NUM_LAYERS);

    for (int l = 0; l < NUM_LAYERS; ++l)
    {
        y[l] = (double *) malloc(sizeof(double *) * NUM_NODES[l]); // also bias
        y[l][NUM_NODES[l] - 1] = BIAS_VALUE;
    }

    for (int j = 0; j < NUM_INPUT_FEATURES; ++j)
    {
        y[0][j] = inputs[j];
    }
    return y;
}

double* InitializeErrors()
{
    double* errors = (double *) malloc (sizeof(double) * NUM_OUTPUT_NODES);
    return errors;
}

double Perceptron(double *x, double *w, int layer, int node)
{
    double net = 0;
    for (int i = 0; i < NUM_NODES[layer]; ++i)
    {
        printf("x[%d] x w[%d] = %f x %f = %f\n", i, i, x[i], w[i], x[i] * w[i]);
        net += (x[i] * w[i]);
    }
    // printf("layer = %d | node = %d\n", layer, node);
    nets[layer][node] = net;
    printf("net = %f | outputs = %f\n", net, ACTIVATION_FUNCTION(net));
    return ACTIVATION_FUNCTION(net);
}

double UnitStep(double net)
{
    // half-maximum convention 
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

double HyperbolicTangent(double v)
{
    // return (2 / (1 + exp(-v))) - 1;
    // return 2 / (1 + exp(-v)) - 1;
    return tanh(v);
}

double DerivativeHyperbolicTangent(double y)
{
    return 2 * y * (1 - y);
}

void FeedForward(double *inputs, double* desired_outputs)
{
    for (int l = 1; l < NUM_LAYERS; ++l)
    {
        for (int j = 0; j < NUM_NODES[l] - 1; ++j)
        {
            outputs[l][j] = Perceptron(outputs[l - 1], weights[l][j], l, j);
            printf("outputs[%d][%d] = %.10f\n", l, j, outputs[l][j]);
            printf("--\n");
        }
    }

    double sum_error = 0;
    for (int j = 0; j < NUM_OUTPUT_NODES; ++j)
    {
        errors[j] = desired_outputs[j] - outputs[OUTPUT_LAYER][j];
        sum_error += errors[j] * errors[j];
        printf("errors[%d] = %.1f - %f = %.10f\n", j, desired_outputs[j], outputs[OUTPUT_LAYER][j], errors[j]);
        printf("desired_outputs[%d] = %.1f\n", j, desired_outputs[j]);
    }
    AverageError += (sum_error / 2);
}

double** InitializeLocalGradients(double **local_gradients)
{
    // Initialize L + 1 layers (0,1,...,L-1)
    local_gradients = (double **) malloc (sizeof(double **) * NUM_LAYERS);

    for (int l = 1; l < NUM_LAYERS; ++l)
    {
        local_gradients[l] = (double *) malloc(sizeof(double *) * NUM_NODES[l] - 1);
    }
    return local_gradients;
}

void CopyWeights()
{
    for (int l = 1; l < NUM_LAYERS; ++l)
    {
        for (int j = 0; j < NUM_NODES[l] - 1; ++j)
        {
            for (int i = 0; i < NUM_NODES[l - 1]; ++i) // also bias
            {
                weights_old[l][j][i] = weights[l][j][i];
            }
        }
    }
}

void BackPropagation()
{
    // printf("> [BackPropogation]\n");

    // Local gradients
    for (int l = OUTPUT_LAYER; l > 0; --l)
    {
        for (int j = 0; j < NUM_NODES[l] - 1; ++j)
        {
            // printf("[LG]: outputs[%d][%d] = %f\n", l, j, outputs[l][j]);
            local_gradients[l][j] = DERIVATIVE_FUNCTION(outputs[l][j]);
            // printf("local_gradients[%d][%d] = %f\n", l, j, DERIVATIVE_FUNCTION(outputs[l][j]));
            // Output layer
            if (l == OUTPUT_LAYER)
            {
                local_gradients[l][j] *= errors[j];
                printf("Derivative fn of nets[%d][%d] = %f\n", l, j, DERIVATIVE_FUNCTION(nets[l][j]));
                printf("local_gradients[%d][%d] = %f x %f = %f\n", l, j, errors[j], DERIVATIVE_FUNCTION(nets[l][j]), local_gradients[l][j]);
            }
            // Hidden layer
            else
            {
                double sum_gradients = 0;
                for (int k = 0; k < NUM_NODES[l + 1] - 1; ++k)
                {
                    printf("sum_gradients = %f + (%f x %f) = %f\n", sum_gradients, local_gradients[l + 1][k], weights[l + 1][k][j], sum_gradients + local_gradients[l + 1][k] * weights[l + 1][k][j]);
                    sum_gradients += (local_gradients[l + 1][k] * weights[l + 1][k][j]);
                }
                printf("local_gradients[%d][%d] = %f x %f = %f\n", l, j, sum_gradients, DERIVATIVE_FUNCTION(outputs[l][j]), local_gradients[l][j] * sum_gradients);
                local_gradients[l][j] *= sum_gradients;
            }
        }
    }

    // printf("[OLD] weights_old[2][0][0] = %f\n", weights_old[2][0][0]);
    CopyWeights();

    // Calculate new weights
    for (int l = 1; l < NUM_LAYERS; ++l)
    {
        for (int j = 0; j < NUM_NODES[l] - 1; ++j)
        {
            for (int i = 0; i < NUM_NODES[l - 1]; ++i)
            {
                // printf("delta_weights[%d][%d][%d] = %.1f x %f x %f = %f\n", l, j, i, LEARNING_RATE, local_gradients[l][j], outputs[l - 1][i], LEARNING_RATE * local_gradients[l][j] * outputs[l - 1][i]);
                delta_weights[l][j][i] = LEARNING_RATE * local_gradients[l][j] * outputs[l - 1][i];
                if (epoch > 1)
                {
                    delta_weights[l][j][i] += (MOMEMTUM_RATE * (weights[l][j][i] - weights_old[l][j][i]));
                }
                weights[l][j][i] += delta_weights[l][j][i];
            }
        }
    }

}

void ReadDataFromFile()
{
    FILE *file = fopen (dataFileName, "r");
    if (file == NULL)
    {
        printf("An error occured reading the file.");
    }
    else
    {
        char line [1024]; // hopefully each line does not exceed 1024 chars
        double num1, num2, num3;
        while (fgets (line, sizeof line, file) != NULL) // reads each line
        {
            ++NUM_INPUT_SAMPLES;
        }
        rewind(file); // reset the pointer to the start of the file

        DataInputs = (double **) malloc(sizeof(double *) * NUM_INPUT_SAMPLES);
        DataOutputs = (double **) malloc(sizeof(double *) * NUM_INPUT_SAMPLES);
        for (int s = 0; s < NUM_INPUT_SAMPLES; ++s)
        {
            DataInputs[s] = (double *) malloc(sizeof(double) * NUM_INPUT_FEATURES);
            DataOutputs[s] = (double *) malloc(sizeof(double) * NUM_OUTPUT_CLASSES);
        }
        int sample = 0;
        while (fgets (line, sizeof line, file) != NULL) // reads each line
        {
            // reads each number into an array
            sscanf(line, "%lf %lf %lf", &num1, &num2, &num3);
            // sscanf(line, XOR_FORMAT);

            // Pre-process data
            // if (num1 == 0) num1 = -1;
            // if (num2 == 0) num2 = -1;
            // if (num3 == 0) num3 = -1;
            if (num1 == 0) num1 = -1 + 0.1;
            else if (num1 == 1) num1 = 1 - 0.1;
            if (num2 == 0) num2 = -1 + 0.1;
            else if (num2 == 1) num2 = 1 - 0.1;
            if (num3 == 0) num3 = -1 + 0.1;
            else if (num3 == 1) num3 = 1 - 0.1;
            DataInputs[sample][0] = num1;
            // printf("DataInputs[%d][0] = %f\n", sample, DataInputs[sample][0]);
            DataInputs[sample][1] = num2;
            // printf("DataInputs[%d][1] = %f\n", sample, DataInputs[sample][1]);
            DataOutputs[sample][0] = num3;
            // printf("DataOutputs[%d][0] = %f\n", sample, DataOutputs[sample][0]);
            ++sample;
        }
        printf("NUM_INPUT_SAMPLES = %d\n", NUM_INPUT_SAMPLES);
        fclose(file);
    }
}

int main()
{
    srand(time(NULL));

    ReadDataFromFile();

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
    NUM_NODES[0] = NUM_INPUT_FEATURES + 1; // +1 for bias
    NUM_INPUT_NODES = NUM_NODES[0] - 1;
    for (int a = 0; a < NUM_HIDDEN_LAYERS; ++a)
    {
        NUM_NODES[a + 1] = NUM_HIDDEN_NODES[a] + 1; // +1 for bias
    }
    NUM_NODES[OUTPUT_LAYER] = NUM_OUTPUT_CLASSES + 1;
    NUM_OUTPUT_NODES = NUM_OUTPUT_CLASSES; //NUM_NODES[OUTPUT_LAYER] - 1

    weights = InitializeWeights(weights);
    weights_old = InitializeWeights(weights_old);
    delta_weights = InitializeWeights(delta_weights);
    nets = InitializeNets(nets);
    outputs = InitializeOutputsAndBias(outputs, DataInputs[0]);
    errors = InitializeErrors();
    local_gradients = InitializeLocalGradients(local_gradients);

    printf("-------------------\n");

    do {
        printf("@ EPOCH# %d\n", epoch);
        AverageError = 0;
        for (int sample = 0; sample < NUM_INPUT_SAMPLES; ++sample)
        {
            printf("@-> SAMPLE# %d\n", sample);
            if (epoch > 1)
            {
                // CopyWeights();
                // CopyDeltaWeights();
            }
            FeedForward(DataInputs[sample], DataOutputs[sample]);
            BackPropagation();
        }
        AverageError /= NUM_INPUT_SAMPLES;
        printf("AverageError = %.10f\n", AverageError);
        ++epoch;
        // if (epoch == 25) exit(1);
    } while(AverageError >= EPSILON_ERROR);
    printf("END @ EPOCH %d\n", epoch);

    return 0;
}
