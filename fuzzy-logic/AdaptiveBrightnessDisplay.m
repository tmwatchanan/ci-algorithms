%clear all;
close all;
global_configs; 

input_fog_density_value = 0;
input_light_level_value = 4900;

for r = 1:size(fuzzy_rules, 1)
  fog_density_membership_value = fog_density_membership_function...
                          (fuzzy_rules(r).fog_density, input_fog_density_value);
  light_level_membership_value = light_level_membership_function...
                          (fuzzy_rules(r).light_level, input_light_level_value);
  firing_strength(r,1) = min(fog_density_membership_value, light_level_membership_value);
endfor

defuzzified_brightness = sum(firing_strength .* [fuzzy_rules.output_mode]') / sum(firing_strength)
