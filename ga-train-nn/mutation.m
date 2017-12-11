for mutated = 1:NUM_CHROMOSOMES
  for layer = 2:NUM_LAYERS
    minAddedWeight = -1;
    maxAddedWeight = 1;
    randomAdded = (maxAddedWeight - (minAddedWeight)) .* rand(NUM_NODES_IN_LAYER(layer) - 1, NUM_NODES_IN_LAYER(layer-1)) + (minAddedWeight);
    weight_children{mutated}{layer} = weight_children{mutated}{layer} + randomAdded;
  endfor
%  chromosome_child = create_chromosome_vector (weight_child, NUM_LAYERS);
%  chromosome_children{mutated} = chromosome_child; % append child
endfor
