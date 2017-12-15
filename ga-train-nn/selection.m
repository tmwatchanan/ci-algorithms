% sort by fitness in ascending order
[sorted_fitness, sorted_indices] = sort(fitness);
Min = 0.5;
Max = 1.5;
sorted_chromosomes = weight_chromosomes(sorted_indices);

% linear ranking selection
for i = 1:NUM_CHROMOSOMES
  p(i) = (Min + (Max-Min)*(i-1)/(NUM_CHROMOSOMES-1)) / NUM_CHROMOSOMES;
endfor
n = p * NUM_CHROMOSOMES;

mating_pool = {};
ptr = uniform_random (0,1);
sus_sum = 0;
i = 1;
while (i <= NUM_CHROMOSOMES)
  sus_sum = sus_sum + n(i);
  while (sus_sum > ptr)
    mating_pool{end + 1, 1} = sorted_chromosomes{i};
    ptr = ptr + 1;
  endwhile
  i = i + 1;
endwhile
