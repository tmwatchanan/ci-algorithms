% Read data from file
FILE_NAME = 'iris.pat';
data = dlmread(FILE_NAME, ' ');
% the number of samples
N = size(data, 1);
% constant involved with the data set
NUM_FEATURES = 4;
NUM_CLASSES = 3;

NUM_HIDDEN_NODES_IN_LAYER = [NUM_FEATURES];
NUM_NODES_IN_LAYER = [NUM_FEATURES + 1; NUM_HIDDEN_NODES_IN_LAYER + 1; NUM_CLASSES]; % add bias nodes for input layer and hidden layers
NUM_LAYERS = size(NUM_NODES_IN_LAYER, 1);
OUTPUT_LAYER = NUM_LAYERS;

LEARNING_RATE = 0.1;
MOMENTUM = 0.1;
BIAS_VALUE = -1;

% condition-break constants
Eav = 100;
EPSILON = 1e-1;
Epoch = 1;
MAX_EPOCH = 10000;

function output = RandomWeight (fanin)
  min = -1 / sqrt(fanin);
  max = -min;
  output = min + (max - min) * rand();
endfunction

% Initialize weights
w = cell(NUM_LAYERS, 1);
for l = 2:NUM_LAYERS
  w{l} = arrayfun(@RandomWeight, ones(NUM_NODES_IN_LAYER(l), NUM_NODES_IN_LAYER(l - 1)) + NUM_NODES_IN_LAYER(l - 1));
endfor

% Initialize outputs and biases
y = cell(NUM_LAYERS, 1);
for l = 1:NUM_LAYERS-1
  y{l} = zeros(NUM_NODES_IN_LAYER(l), 1);
  y{l}(end) = BIAS_VALUE;
end

net = cell(NUM_LAYERS, 1);

while (Eav > EPSILON && Epoch < MAX_EPOCH)
  % shuffle samples for pick unique random x
  input_data = data(randperm(size(data,1)), 1:end);
  % for every samples
  for n = 1:N
    % inputs
    x = input_data(1, 1:NUM_FEATURES);
    % desired outputs / targets
    d = input_data(1, end-NUM_CLASSES+1:end);
    % remove the first used sample
    input_data = input_data(2:end, :);
    
    % input-layer outputs are input vector
    y{1}(1:NUM_FEATURES) = x(1, 1:NUM_FEATURES)';
    
    % copy old weights
    w_old = w;
    
    % forward pass
    for l = 2:NUM_LAYERS
      net{l} = w{l} * y{l-1};
      y{l} = arrayfun(@HyperbolicTangent, net{l});
    endfor
    % error
    e = d' - y{OUTPUT_LAYER};
    
    % backward pass
    % local gradients at output layer
    local_gradients{OUTPUT_LAYER} = e .* arrayfun(@DerivativeHyperbolicTangent, y{OUTPUT_LAYER});
    % local gradients at hidden layers
    for l = NUM_LAYERS-1:-1:2
      sum_gradients = local_gradients{l + 1}' * w{l + 1};
      local_gradients{l} = arrayfun(@DerivativeHyperbolicTangent, y{l}(1:end-1, :)) .*  sum_gradients';
    endfor
    % adjust weights
    for l = 2:NUM_LAYERS
      delta_w{l} = (MOMENTUM .* sum(w{l} - w_old{l})) + (LEARNING_RATE .* local_gradients{l} .* y{l - 1});
    endfor
  endfor
endwhile

function output = HyperbolicTangent (v)
  output = (2 / (1 + exp(-v))) - 1;
endfunction

function output = DerivativeHyperbolicTangent (y)
  output = 2 * y * (1 - y);
endfunction

