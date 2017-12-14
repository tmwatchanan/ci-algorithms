clear all;
close all;
global_configs;

input_fog_density_value = 0.03;
input_light_level_value = 5000;
input_brightness_value = 50;

fuzzy_rules = [];

fuzzy_rules = add_fuzzy_rule(fuzzy_rules, "thin","very_dark","very_low");
fuzzy_rules = add_fuzzy_rule(fuzzy_rules, "thin","dark","low");
fuzzy_rules = add_fuzzy_rule(fuzzy_rules, "thin","medium","moderate");
fuzzy_rules = add_fuzzy_rule(fuzzy_rules, "thin","bright","high");
fuzzy_rules = add_fuzzy_rule(fuzzy_rules, "thin","very_bright","very_high");

fuzzy_rules = add_fuzzy_rule(fuzzy_rules, "medium","very_dark","moderate");
fuzzy_rules = add_fuzzy_rule(fuzzy_rules, "medium","dark","moderate");
fuzzy_rules = add_fuzzy_rule(fuzzy_rules, "medium","medium","high");
fuzzy_rules = add_fuzzy_rule(fuzzy_rules, "medium","bright","high");
fuzzy_rules = add_fuzzy_rule(fuzzy_rules, "medium","very_bright","very_high");

fuzzy_rules = add_fuzzy_rule(fuzzy_rules, "thick","very_dark","very_high");
fuzzy_rules = add_fuzzy_rule(fuzzy_rules, "thick","dark","very_high");
fuzzy_rules = add_fuzzy_rule(fuzzy_rules, "thick","medium","very_high");
fuzzy_rules = add_fuzzy_rule(fuzzy_rules, "thick","bright","very_high");
fuzzy_rules = add_fuzzy_rule(fuzzy_rules, "thick","very_bright","very_high");

for r = 1:size(fuzzy_rules, 1)
  fog_density_membership_value = fog_density_membership_function...
                          (fuzzy_rules(r).fog_density, input_fog_density_value);
                            
  light_level_membership_value = light_level_membership_function...
                          (fuzzy_rules(r).light_level, input_light_level_value);
  
endfor
