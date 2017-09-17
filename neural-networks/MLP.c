#include <stdio.h>
#include <time.h>
#include <stdlib.h>
#include <math.h>

#define SIZE_OF(array) sizeof((array))/sizeof((array)[0])

#define NUM_INPUT_NODES 2
const int NUM_HIDDEN_NODES[] = {0};
#define NUM_OUTPUT_NODES 1
const int NUM_HIDDEN_LAYERS = (int)(sizeof(NUM_HIDDEN_NODES) / sizeof(NUM_HIDDEN_NODES[0]));
const int NUM_LAYERS = 1 + NUM_HIDDEN_LAYERS + 1;
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

void InitializeWeights()
{
    // Input Layer
    // weights[0] = malloc(NUM_NODES[1]*sizeof(int *));
    // for(int i = 0 ; i < NUM_NODES[1]; i++)
    //     weights[0][i] = malloc( NUM_NODES[0]*sizeof(int) );

    // Hidden Layer(s)
    for (int layer = 1; layer != NUM_LAYERS - 1; ++layer)
    {
        // for (int j = 0; j != )
    }

    // Output Layer
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

void FeedForward()
{

}

int main()
{
    srand(time(NULL));

    NUM_NODES = (int *)malloc(sizeof(int)*NUM_LAYERS);
    NUM_NODES[0] = NUM_INPUT_NODES;
    for (int a = 0; a != NUM_HIDDEN_LAYERS; ++a)
    {
        NUM_NODES[a + 1] = NUM_HIDDEN_NODES[a];
    }
    NUM_NODES[NUM_LAYERS - 1] = NUM_OUTPUT_NODES;
    
    weights = (double ***) malloc (sizeof(double ***)*NUM_LAYERS);
    for (int h = 0; h < NUM_LAYERS - 1; h++)
    {
        weights[h] = (double **) malloc(sizeof(double*)*NUM_NODES[h]);
        for (int r = 0; r < NUM_NODES[h]; r++)
        {
            weights[h][r] = (double *) malloc(sizeof(double)*NUM_NODES[r]);
        }
    }

    double x[2] = {1, 1};
    double w[2] = {1, 1};
    printf("y = %f", Perceptron(x, w));

    return 0;
}