%clear all;
close all;
global_configs; 

%input_fog_density_value = uniform_random(0, 0.05) % LWC "Thin"
%input_fog_density_value = uniform_random(0.03, 0.3) % LWC "Medium"
%input_fog_density_value = uniform_random(0.3, 3.0) % LWC "Thick"

%input_light_level_value = uniform_random(0, 200) % Light Level "VeryDark"
%input_light_level_value = uniform_random(100, 950) % Light Level "Dark"
%input_light_level_value = uniform_random(900, 2100) % Light Level "Medium"
%input_light_level_value = uniform_random(2000, 11000) % Light Level "Bright"
%input_light_level_value = uniform_random(10000, 12000) % Light Level "VeryBright"

for r = 1:size(fuzzy_rules, 1)
  fog_density_membership_value = fog_density_membership_function...
                          (fuzzy_rules(r).fog_density, input_fog_density_value);
  light_level_membership_value = light_level_membership_function...
                          (fuzzy_rules(r).light_level, input_light_level_value);
  firing_strength(r,1) = min(fog_density_membership_value, light_level_membership_value);
endfor

defuzzified_brightness = sum(firing_strength .* [fuzzy_rules.output_mode]') / sum(firing_strength)
