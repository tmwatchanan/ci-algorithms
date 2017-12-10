close all;
clear all;
more off;
% Saving figures
OPEN_FIGURES = 0;
SAVE_FIGURES = 1;
% parameters setup
NUM_HIDDEN_NODES_IN_LAYER = [8];
LEARNING_RATE = 0.5;
MOMENTUM = 0.5;
K_fold = 10; % 0
BIAS_VALUE = 1;
% condition-break constants
EPSILON = 1e-2;
MAX_GENERATION = 500;
% Read data from file wdbc.data = Wisconsin Diagnostic Breast Cancer (WDBC)
FILE_NAME = "wdbc_numeric.data";
wdbc = dlmread(FILE_NAME, ",");
NUM_FEATURES = 30;
NUM_CLASSES = 2;
CLASSES_INDEX = 2;
FEATURES_INDEX = 3:size(wdbc, 2);
% genetic algorithm (GA)
NUM_CHROMOSOMES = 50;

numHiddenNodesForString = sprintf("%g-" , NUM_HIDDEN_NODES_IN_LAYER);
numHiddenNodesForString = numHiddenNodesForString(1:end-1);% strip final comma
SAVE_DIRNAME = [FILE_NAME "-lr" num2str(LEARNING_RATE) "-mo" num2str(MOMENTUM) "-node" num2str(numHiddenNodesForString)];

% the number of samples
N = size(wdbc, 1);
% scaling features
features_data = wdbc(:, FEATURES_INDEX);
wdbc(:, FEATURES_INDEX) = normalize_features(features_data);
% desired outputs and scaling using Logistic function
desired_output_data = wdbc(:, CLASSES_INDEX);
desired_output_data(desired_output_data == 1) = 0.9;
desired_output_data(desired_output_data == 0) = 0.1;
wdbc(:, CLASSES_INDEX) = desired_output_data;

NUM_NODES_IN_LAYER = [NUM_FEATURES + 1; NUM_HIDDEN_NODES_IN_LAYER + 1; NUM_CLASSES + 1]; % add bias nodes for input layer and hidden layers
NUM_LAYERS = size(NUM_NODES_IN_LAYER, 1);
OUTPUT_LAYER = NUM_LAYERS;

% randomly initialize weights
w = cell(NUM_LAYERS, 1);
for l = 2:NUM_LAYERS
  w{l} = arrayfun(@random_weight, ones(NUM_NODES_IN_LAYER(l) - 1, NUM_NODES_IN_LAYER(l - 1)));
  delta_w{l} = ones(NUM_NODES_IN_LAYER(l) - 1, NUM_NODES_IN_LAYER(l - 1));
endfor

% initialize outputs and biases
y = cell(NUM_LAYERS, 1);
for l = 1:NUM_LAYERS-1
  y{l} = zeros(NUM_NODES_IN_LAYER(l) - 1, 1); % nodes
  y{l}(NUM_NODES_IN_LAYER(l), 1) = BIAS_VALUE; % bias
end

% fixed data for every k
original_w = w;
original_y = y;
original_data = wdbc;
[training_sets, test_sets, _] = split_k_fold (wdbc, K_fold);
% for each fold
for k = 1:K_fold
  % load initial data for every k
  y = original_y;
  % weights
  weights = cell(1, NUM_CHROMOSOMES);
  weights(:) = {original_w};
  % initialize break-loop variables
  wdbc = training_sets{k};
  generation = 1;
  Eav = 100;
  avError = [];
  while (Eav > EPSILON && generation < MAX_GENERATION)
    % for every chromosome (network weights)
    for c = 1:NUM_CHROMOSOMES
      w = weights{c};
      % shuffle samples for pick unique random x
      input_data = wdbc(randperm(size(wdbc,1)), 1:end);
      % set the sum of squared errors to 0 in each 
      E = 0;
      % initialize arrays for confusion matrix
      y_output = [];
      d_output = [];
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
        
        % copy old weights
        w_old = w;
        
        % forward pass
        for l = 2:NUM_LAYERS
          net{l} = w{l} * y{l-1};
          y{l}(1:NUM_NODES_IN_LAYER(l)-1, 1) = arrayfun(@logistic, net{l}); % only actual nodes, except bias nodes
        endfor
        % correct outputs for confusion matrix
        y_output = [y_output; y{OUTPUT_LAYER}'];
        d_output = [d_output; d'];
        % error
        e = d - y{OUTPUT_LAYER};
        E = E + (0.5 * sum(e.^2)); % sum of squared errors
      endfor
      Eav = E / fold_size; % mean squared error (MSE)
      avError = [avError Eav];
      generation = generation + 1;
      fflush(stdout);
    endfor % all chromosomes done
    % remapping : evaluate fitness of all chromosomes in a generation
    fitness = evaluate_fitness (avError);
    % crossover C(2,1) -> 2 parents give 1 child
    for xover = 1:NUM_CHROMOSOMES
      parent_indices = randperm(size(w,1), 2); % randomly select parents
      weight_parents{1} = weights{parent_indices(1)}; % father's chromosome
      weight_parents{2} = weights{parent_indices(2)}; % mother's chromosome
      weight_child = weight_parents{1}; % take all weights from parent first
      for layer = 2:NUM_LAYERS
        for node = 1:NUM_NODES_IN_LAYER(layer)-1
          if (randperm(2, 1) == 2) % select weights from mother instead
            weight_child{layer}(node) = weight_parents{2}{layer}(node);
          endif
        endfor
      endfor
      weight_children{xover} = weight_child;
    endfor
    % mutation
    for mutated = 1:NUM_CHROMOSOMES
      for layer = 2:NUM_LAYERS
        minAddedWeight = -1;
        maxAddedWeight = 1;
        randomAdded = (maxAddedWeight - (minAddedWeight)) .* rand(NUM_NODES_IN_LAYER(layer) - 1, NUM_NODES_IN_LAYER(layer-1)) + (minAddedWeight);
        weight_children{mutated}{layer} = weight_children{mutated}{layer} + randomAdded;
      endfor
%      chromosome_child = create_chromosome_vector (weight_child, NUM_LAYERS);
%      chromosome_children{mutated} = chromosome_child; % append child
    endfor
    weights = weight_children;
  endwhile
  
  avErrors{k} = avError;
  Eav_train(k) = Eav;
  
  % confusion matrix for training set
  if OPEN_FIGURES || SAVE_FIGURES
    figure(k, "Position", [0,0,500,180]);
    CONFUSION_MATRIX_NAME = "Training Set";
    CONFUSION_MATRIX_SUBPLOT_POSITION = 1;
    ConfusionMatrix;
  endif  
  
  % Test the validation set
  % shuffle samples for pick unique random x
  wdbc = test_sets{k};
  input_data = wdbc(randperm(size(wdbc,1)), 1:end);
  % set Eav to 0 in each generation
  Eav = 0;
  y_output = d_output = [];
  y = original_y;
  fold_size = size(input_data, 1);
  for n = 1:fold_size
    % inputs
    x = input_data(1, FEATURES_INDEX);
    % desired outputs / targets
    d = input_data(1, CLASSES_INDEX)';
    % remove the first used sample
    input_data = input_data(2:end, :);
    % input-layer outputs are input vector
    y{1}(1:NUM_FEATURES, 1) = x(1, 1:NUM_FEATURES)';
    for l = 2:NUM_LAYERS
      net{l} = w{l} * y{l-1};
      y{l}(1:NUM_NODES_IN_LAYER(l)-1, 1) = arrayfun(@logistic, net{l}); % only actual nodes, except bias nodes
    endfor
    % error
    e = d - y{OUTPUT_LAYER};
    Eav = Eav + (0.5 * sum(e.^2));
    y_output = [y_output; y{OUTPUT_LAYER}'];
    d_output = [d_output; d'];
  endfor
  
  % Confusion matrix for validation set
  if OPEN_FIGURES || SAVE_FIGURES
    CONFUSION_MATRIX_NAME = 'Validation Set';
    CONFUSION_MATRIX_SUBPLOT_POSITION = 2;
    ConfusionMatrix;
  endif  
    
  generations(k) = generation;
  Eav_test(k) = Eav;
  weights{k} = w;
  y_outputs{k} = y_output;
  d_outputs{k} = d_output;
  printf("{K = %d} #generation=%d\tAverage Error (Train = %.4f) (Test = %.3f)\n", k, generations(k), Eav_train(k), Eav_test(k));
endfor

PlotErrorGraph;

[_, best_k] = min(Eav_test);
printf("[Best performance @ k = %d] ------\n(train error\t= %.4f)\n(test error\t= %.3f)\n", best_k, Eav_train(best_k), Eav_test(best_k));