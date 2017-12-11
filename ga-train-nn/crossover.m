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
