close all;
clear all;
more off;
% Saving figures
OPEN_FIGURES = 0;
SAVE_FIGURES = 1;
% Read data from file
%FILE_NAME = 'iris.pat';
FILE_NAME = 'cross.pat';
data = dlmread(FILE_NAME, 'c ');
% parameters setup
NUM_HIDDEN_NODES_IN_LAYER = [18];
LEARNING_RATE = 0.1;
MOMENTUM = 0.1;
K_fold = 10; % 0
BIAS_VALUE = 1;
% condition-break constants
EPSILON = 1e-2;
MAX_EPOCH = 5000;
% constant involved with the data set
if strcmp(FILE_NAME, 'iris.pat')
  NUM_FEATURES = 4;
  NUM_CLASSES = 3;
elseif strcmp(FILE_NAME, 'cross.pat')
  NUM_FEATURES = 2;
  NUM_CLASSES = 2;
endif

numHiddenNodesForString = sprintf('%g-' , NUM_HIDDEN_NODES_IN_LAYER);
numHiddenNodesForString = numHiddenNodesForString(1:end-1);% strip final comma
SAVE_DIRNAME = [FILE_NAME "-lr" num2str(LEARNING_RATE) "-mo" num2str(MOMENTUM) "-node" num2str(numHiddenNodesForString)];

% the number of samples
N = size(data, 1);
% Scaling data set
features_data = data(:, 1:NUM_FEATURES);
mean = sum(features_data) / size(features_data, 1);
sd = (sum((features_data - mean) .^ 2) ./ (N - 1)) .^ 0.5;
features_data = (features_data - mean) ./ repmat(sd, size(features_data, 1), 1);
data(:, 1:NUM_FEATURES) = features_data;
% Scaling desired outputs
desired_output_data = data(:, end-NUM_CLASSES+1:end);
% Scaling targets for HyperbolicTangent
%desired_output_data(desired_output_data == 1) = 0.9;
%desired_output_data(desired_output_data == 0) = -0.9;
% Scaling targets for Logistic
desired_output_data(desired_output_data == 1) = 0.9;
desired_output_data(desired_output_data == 0) = 0.1;
data(:, end-NUM_CLASSES+1:end) = desired_output_data;

NUM_NODES_IN_LAYER = [NUM_FEATURES + 1; NUM_HIDDEN_NODES_IN_LAYER + 1; NUM_CLASSES + 1]; % add bias nodes for input layer and hidden layers
NUM_LAYERS = size(NUM_NODES_IN_LAYER, 1);
OUTPUT_LAYER = NUM_LAYERS;

function output = RandomWeight (fanin)
  min = -1 / sqrt(fanin);
  max = -min;
  output = min + (max - min) * rand();
endfunction

% Initialize weights
w = cell(NUM_LAYERS, 1);
for l = 2:NUM_LAYERS
  w{l} = arrayfun(@RandomWeight, ones(NUM_NODES_IN_LAYER(l) - 1, NUM_NODES_IN_LAYER(l - 1)));
  delta_w{l} = ones(NUM_NODES_IN_LAYER(l) - 1, NUM_NODES_IN_LAYER(l - 1));
endfor

% Initialize outputs and biases
y = cell(NUM_LAYERS, 1);
for l = 1:NUM_LAYERS-1
  y{l} = zeros(NUM_NODES_IN_LAYER(l) - 1, 1);
  y{l}(NUM_NODES_IN_LAYER(l), 1) = BIAS_VALUE;
end

function output = HyperbolicTangent (v)
  output = (2 / (1 + exp(-v))) - 1;
endfunction

function output = DerivativeHyperbolicTangent (y)
  output = 2 * y * (1 - y);
endfunction

function output = Logistic (v)
  output = 1 / (1 + exp(-v));
endfunction

function output = DerivativeLogistic (y)
  output = y * (1 - y);
endfunction

% Fixed data for every k
original_w = w;
original_y = y;
original_data = data;
[training_sets, test_sets, N_fold] = KFold (data, K_fold);
% for each fold
for k = 1:K_fold
  % Load initial data for every k
  w = original_w;
  y = original_y;
  data = training_sets{k};
  % Initialize break-loop variables
  Epoch = 1;
  Eav = 100;
  avError = [];
  while (Eav > EPSILON && Epoch < MAX_EPOCH)
    % shuffle samples for pick unique random x
    input_data = data(randperm(size(data,1)), 1:end);
    % set Eav to 0 in each epoch
    Eav = 0;
    % initialize arrays for confusion matrix
    y_output = [];
    d_output = [];
    % for every samples
    for n = 1:N_fold
      % inputs
      x = input_data(1, 1:NUM_FEATURES);
      % desired outputs / targets
      d = input_data(1, end-NUM_CLASSES+1:end)';
      % remove the first used sample
      input_data = input_data(2:end, :);
      
      % input-layer outputs are input vector
      y{1}(1:NUM_FEATURES, 1) = x(1, 1:NUM_FEATURES)';
      
      % copy old weights
      w_old = w;
      
      % forward pass
      for l = 2:NUM_LAYERS
        net{l} = w{l} * y{l-1};
        y{l}(1:NUM_NODES_IN_LAYER(l)-1, 1) = arrayfun(@Logistic, net{l}); % only actual nodes, except bias nodes
      endfor
      % correct outputs for confusion matrix
      y_output = [y_output; y{OUTPUT_LAYER}'];
      d_output = [d_output; d'];
      % error
      e = d - y{OUTPUT_LAYER};
      Eav = Eav + (0.5 * sum(e.^2));
      
      % Show outputs
%      printf("[EPOCH @ %d] ", Epoch);
%      printf("x=");
%      printf(mat2str(x, 2));
%      printf(" (y=");
%      printf(mat2str(y{OUTPUT_LAYER}, 2));
%      printf(", d=");
%      printf(mat2str(d));
%      printf(")\n");

  %    fprintf("] -- w{3} = ");
  %    disp(mat2str(w{3}, 2));
  %    disp(['w{2}=' mat2str(w{2})]);
  %    disp(['w{3}=' mat2str(w{3})]);
      
      % backward pass
      % local gradients at output layer
      local_gradients{OUTPUT_LAYER} = e .* arrayfun(@DerivativeLogistic, y{OUTPUT_LAYER});
      % local gradients at hidden layers
      for l = NUM_LAYERS-1:-1:2
        sum_gradients = w{l + 1}(:, 1:NUM_NODES_IN_LAYER(l)-1)' * local_gradients{l + 1};
        local_gradients{l} = arrayfun(@DerivativeLogistic, y{l}(1:NUM_NODES_IN_LAYER(l)-1, :)) .*  sum_gradients;
      endfor
      % adjust weights
  %    for l = 2:NUM_LAYERS
  %      for j = 1:NUM_NODES_IN_LAYER(l) - 1
  %        for i = 1:NUM_NODES_IN_LAYER(l - 1)
  %          delta_w{l}(j, i) = MOMENTUM * (w{l}(j, i) - w_old{l}(j, i)) + LEARNING_RATE * local_gradients{l}(j) * y{l-1}(i);
  %          w{l}(j, i) = w{l}(j, i) + delta_w{l}(j, i);
  %        endfor  
  %      endfor
  %    endfor
      for l = 2:NUM_LAYERS
        delta_w{l} = MOMENTUM .* (w{l} - w_old{l}) .+ LEARNING_RATE .* (local_gradients{l} * y{l-1}(1:NUM_NODES_IN_LAYER(l-1), 1)');
        w{l} = w{l} + delta_w{l};
      endfor
    endfor
    Eav = Eav / N_fold;
    avError = [avError Eav];
    Epoch = Epoch + 1;
    
%    disp('---');
    fflush(stdout);
  endwhile
  
  avErrors{k} = avError;
  Eav_train(k) = Eav;
  
  % Confusion matrix for training set
  if OPEN_FIGURES || SAVE_FIGURES
    % Open figure for confusion matrices
%    figure(k);
    figure(k, 'Position', [0,0,500,180]);
    CONFUSION_MATRIX_NAME = 'Training Set';
    CONFUSION_MATRIX_SUBPLOT_POSITION = 1;

    ConfusionMatrix;
  endif  
  
  % Test the validation set
  % shuffle samples for pick unique random x
  data = test_sets{k};
  input_data = data(randperm(size(data,1)), 1:end);
  % set Eav to 0 in each epoch
  Eav = 0;
  y_output = d_output = [];
  y = original_y;
  for n = 1:N_fold
    % inputs
    x = input_data(1, 1:NUM_FEATURES);
    % desired outputs / targets
    d = input_data(1, end-NUM_CLASSES+1:end)';
    % remove the first used sample
    input_data = input_data(2:end, :);
    % input-layer outputs are input vector
    y{1}(1:NUM_FEATURES, 1) = x(1, 1:NUM_FEATURES)';
    for l = 2:NUM_LAYERS
      net{l} = w{l} * y{l-1};
      y{l}(1:NUM_NODES_IN_LAYER(l)-1, 1) = arrayfun(@Logistic, net{l}); % only actual nodes, except bias nodes
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
    
  Epochs(k) = Epoch;
  Eav_test(k) = Eav;
  weights{k} = w;
  y_outputs{k} = y_output;
  d_outputs{k} = d_output;
  printf("{K = %d} #epoch=%d\tAverage Error (Train = %.4f) (Test = %.3f)\n", k, Epochs(k), Eav_train(k), Eav_test(k));
endfor

PlotErrorGraph;

[_, best_k] = min(Eav_test);
printf("[Best performance @ k = %d] ------\n(train error\t= %.4f)\n(test error\t= %.3f)\n", best_k, Eav_train(best_k), Eav_test(best_k));