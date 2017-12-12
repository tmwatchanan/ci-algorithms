minAddedWeight = -1;
maxAddedWeight = 1;
for mutated = 1:NUM_CHROMOSOMES
  for layer = 2:NUM_LAYERS
    randomAdded = uniform_random(minAddedWeight, maxAddedWeight, NUM_NODES_IN_LAYER(layer) - 1, NUM_NODES_IN_LAYER(layer-1));
    randomMutated = uniform_random(minAddedWeight, maxAddedWeight, NUM_NODES_IN_LAYER(layer) - 1, NUM_NODES_IN_LAYER(layer-1));
    randomMutated = randomMutated < MUTATION_RATE;
    randomAdded = randomAdded .* randomMutated;
    weight_children{mutated}{layer} = weight_children{mutated}{layer} + randomAdded;
  endfor
%  chromosome_child = create_chromosome_vector (weight_child, NUM_LAYERS);
%  chromosome_children{mutated} = chromosome_child; % append child
endfor
