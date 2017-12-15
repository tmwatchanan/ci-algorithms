close all;
clear all;
more off;
%tic;

run_params_HIDDEN{1} = [2];
run_params_HIDDEN{2} = [4];
run_params_HIDDEN{3} = [6];

%run_params_HIDDEN{1} = [0];
%run_params_HIDDEN{2} = [2];
%run_params_HIDDEN{3} = [4];
%run_params_HIDDEN{4} = [6];
%run_params_HIDDEN{5} = [4];
%run_params_HIDDEN{6} = [6];
%run_params_HIDDEN{7} = [7];
%run_params_HIDDEN{8} = [8];
%run_params_HIDDEN{9} = [2;2];
%run_params_HIDDEN{10} = [2;4];
%run_params_HIDDEN{11} = [4;2];
%run_params_HIDDEN{12} = [4;4];
%run_params_HIDDEN{13} = [4;4;4];

for SUPER_LOOP = 1:size(run_params_HIDDEN,2)

% Saving figures
OPEN_FIGURES = 0;
SAVE_FIGURES = 1;
% parameters setup
%NUM_HIDDEN_NODES_IN_LAYER = [5];
NUM_HIDDEN_NODES_IN_LAYER = run_params_HIDDEN{SUPER_LOOP};
% genetic algorithm (GA)
NUM_CHROMOSOMES = 50;
MUTATION_RATE = 0.05; % [0.001, 0.01]
% condition-break constants
MAX_GENERATION = 150;
% MLP
BIAS_VALUE = 1;
% cross validation
K_fold = 10; % 0 for no cross validation

% Read data from file wdbc.data = Wisconsin Diagnostic Breast Cancer (WDBC)
FILE_NAME = "wdbc-numeric.data";
wdbc = dlmread(FILE_NAME, ",");
NUM_FEATURES = 30;
NUM_CLASSES = 2;
CLASSES_INDEX = 1:2;
FEATURES_INDEX = 3:size(wdbc, 2);

numHiddenNodesForString = sprintf("%g-" , NUM_HIDDEN_NODES_IN_LAYER);
numHiddenNodesForString = numHiddenNodesForString(1:end-1);% strip final comma
SAVE_DIRNAME = [FILE_NAME "-gen" num2str(MAX_GENERATION) "-ch" num2str(NUM_CHROMOSOMES) "-mu" num2str(MUTATION_RATE) "-node" num2str(numHiddenNodesForString)];

% the number of samples
N = size(wdbc, 1);
% normalize and scale features
for f_idx = FEATURES_INDEX
  wdbc(:, f_idx) = normalize_features(wdbc(:, f_idx));
endfor
features_data = wdbc(:, FEATURES_INDEX);
% desired outputs and scaling using Logistic function
desired_output_data = wdbc(:, CLASSES_INDEX);
desired_output_data(desired_output_data == 1) = 0.9;
desired_output_data(desired_output_data == 0) = 0.1;
wdbc(:, CLASSES_INDEX) = desired_output_data;

NUM_NODES_IN_LAYER = [NUM_FEATURES + 1; NUM_HIDDEN_NODES_IN_LAYER + 1; NUM_CLASSES + 1]; % add bias nodes for input layer and hidden layers
NUM_LAYERS = size(NUM_NODES_IN_LAYER, 1);
OUTPUT_LAYER = NUM_LAYERS;

% randomly initialize weights
for ch = 1:NUM_CHROMOSOMES
  w = cell(NUM_LAYERS, 1);
  for l = 2:NUM_LAYERS
    w{l} = arrayfun(@random_weight, ones(NUM_NODES_IN_LAYER(l) - 1, NUM_NODES_IN_LAYER(l - 1)));
    delta_w{l} = ones(NUM_NODES_IN_LAYER(l) - 1, NUM_NODES_IN_LAYER(l - 1));
  endfor
  original_weight_chromosomes{ch} = w;
endfor

% initialize outputs and biases
y = cell(NUM_LAYERS, 1);
for l = 1:NUM_LAYERS-1
  y{l} = zeros(NUM_NODES_IN_LAYER(l) - 1, 1); % nodes
  y{l}(NUM_NODES_IN_LAYER(l), 1) = BIAS_VALUE; % bias
end

% fixed data for every k
original_y = y;
[training_sets, test_sets, _] = split_k_fold (wdbc, K_fold);
% for each fold
for k = 1:K_fold
  % load initial data for every k
  y = original_y;
  % load initial weights
  weight_chromosomes = original_weight_chromosomes;
  % initialize break-loop variables
  wdbc = training_sets{k};
  generation = 1;
  fitness_all_gen_in_one_fold = [];
  % [train] the validation set -------------------------------------------------
  while (generation < MAX_GENERATION)
    generation
    % for every chromosome (network weights)
    MSE = zeros(NUM_CHROMOSOMES,1); % initialize MSE of every chromomes to 0
    fitness = zeros(NUM_CHROMOSOMES,1);
    for c = 1:NUM_CHROMOSOMES % 1 network = 1 chromosome
      w = weight_chromosomes{c};
      % shuffle samples for pick unique random x
      input_data = wdbc(randperm(size(wdbc,1)), 1:end);
      % set the sum of squared errors to 0 in each 
      E = 0;
      y_output = [];
      % initialize arrays for confusion matrix
      d_output = [];
      fold_size = size(input_data, 1);
      % for every samples
      for n = 1:fold_size
        x = input_data(1, FEATURES_INDEX); % inputs
        d = input_data(1, CLASSES_INDEX)'; % desired outputs / targets
        input_data = input_data(2:end, :); % remove the first used sample
        y{1}(1:NUM_FEATURES, 1) = x(1, 1:NUM_FEATURES)'; % input-layer outputs are input vector
        w_old = w; % copy old weights
        
        % forward pass
        for l = 2:NUM_LAYERS
          net{l} = w{l} * y{l-1};
          y{l}(1:NUM_NODES_IN_LAYER(l)-1, 1) = arrayfun(@logistic, net{l}); % only actual nodes, except bias nodes
        endfor
        
        y_output = [y_output; y{OUTPUT_LAYER}']; % collect outputs for confusion matrix
        d_output = [d_output; d']; % collect outputs for confusion matrix
        e = d - y{OUTPUT_LAYER}; % error between desired and actual output
        E = E + (0.5 * sum(e.^2)); % sum of squared errors
      endfor % done every samples
      MSE(c) = E / fold_size; % mean squared error
      fitness(c) = evaluate_fitness (MSE(c)); % remapping from MSE to fitness
      % store output for confusion matrix
      y_output_last_gen_of_chromosome{c} = y_output;
      d_output_last_gen_of_chromosome{c} = d_output;
    endfor % done all chromosomes
    fitness_all_gen_in_one_fold = [fitness_all_gen_in_one_fold, sum(fitness)];
    weights_of_gen{generation} = weight_chromosomes;
    average_MSE_of_gen(generation) = sum(MSE) / fold_size;
    [_, best_chromosome_of_gen(generation)] = max(fitness);
    selection;
    crossover; % C(2,1) -> 2 parents give 1 child
    mutation; % mutate for every non-input nodes
    weight_chromosomes = weight_children;
    generation = generation + 1;
  endwhile
  average_fitness_all_gen_in_one_fold = fitness_all_gen_in_one_fold ./ NUM_CHROMOSOMES;
  average_fitness_of_k_fold{k} = average_fitness_all_gen_in_one_fold;
  
  % pick the best chromosome of fold k
  w = weights_of_gen{end}{best_chromosome_of_gen(end)};
  
  % confusion matrix for training set
  if OPEN_FIGURES || SAVE_FIGURES
    figure(k, "Position", [0,0,500,180]);
    CONFUSION_MATRIX_NAME = "Training Set";
    CONFUSION_MATRIX_SUBPLOT_POSITION = 1;
    y_output = y_output_last_gen_of_chromosome{best_chromosome_of_gen(end)};
    d_output = d_output_last_gen_of_chromosome{best_chromosome_of_gen(end)};
    plot_confusion_matrix;
  endif  
 
  % [test] the validation set --------------------------------------------------
  % shuffle samples for pick unique random x
  wdbc = test_sets{k};
  input_data = wdbc(randperm(size(wdbc,1)), 1:end);
  y_output = d_output = [];
  y = original_y;
  fold_size = size(input_data, 1);
  % for every samples
  for n = 1:fold_size
    % inputs
    x = input_data(1, FEATURES_INDEX);
    % desired outputs / targets
    d = input_data(1, CLASSES_INDEX)';
    % remove the first used sample
    input_data = input_data(2:end, :);
    % input-layer outputs are input vector
    y{1}(1:NUM_FEATURES, 1) = x(1, 1:NUM_FEATURES)';
    % feed forward
    for l = 2:NUM_LAYERS
      net{l} = w{l} * y{l-1};
      y{l}(1:NUM_NODES_IN_LAYER(l)-1, 1) = arrayfun(@logistic, net{l}); % only actual nodes, except bias nodes
    endfor
    % error
    e = d - y{OUTPUT_LAYER};
    E = E + (0.5 * sum(e.^2));
    y_output = [y_output; y{OUTPUT_LAYER}'];
    d_output = [d_output; d'];
  endfor
  MSE_test_best_chromosome(k) = sum(E) / fold_size;
  
  % confusion matrix for validation set
  if OPEN_FIGURES || SAVE_FIGURES
    CONFUSION_MATRIX_NAME = 'Validation Set';
    CONFUSION_MATRIX_SUBPLOT_POSITION = 2;
    plot_confusion_matrix;
  endif  
    
  generations(k) = generation;
  weights{k} = w;
  y_outputs{k} = y_output;
  d_outputs{k} = d_output;
%  printf("{K = %d} #generation=%d\tAverage Error (Train = %.4f) (Test = %.3f)\n", k, generations(k), Eav_train(k), Eav_test(k));
printf("{K = %d} #generation=%d\t\n", k, generations(k));
endfor

%plot_error_graph;
plot_fitness;

[_, best_k] = min(MSE_test_best_chromosome);
%printf("[Best performance @ k = %d] ------\n(train error\t= %.4f)\n(test error\t= %.3f)\n", best_k, Eav_train(best_k), Eav_test(best_k));
printf("[Best performance @ k = %d] ------\n", best_k);
%toc;

endfor
