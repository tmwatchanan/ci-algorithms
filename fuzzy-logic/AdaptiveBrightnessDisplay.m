%clear all;
close all;
global_configs;

input_fog_density_value = 0.03;
input_light_level_value = 5000;
input_brightness_value = 50;

fuzzy_rules = [];

fuzzy_rules = add_fuzzy_rule(fuzzy_rules, "Thin","VeryDark","VeryLow");
fuzzy_rules = add_fuzzy_rule(fuzzy_rules, "Thin","Dark","Low");
fuzzy_rules = add_fuzzy_rule(fuzzy_rules, "Thin","Medium","Moderate");
fuzzy_rules = add_fuzzy_rule(fuzzy_rules, "Thin","Bright","High");
fuzzy_rules = add_fuzzy_rule(fuzzy_rules, "Thin","VeryBright","VeryHigh");

fuzzy_rules = add_fuzzy_rule(fuzzy_rules, "Medium","VeryDark","Moderate");
fuzzy_rules = add_fuzzy_rule(fuzzy_rules, "Medium","Dark","Moderate");
fuzzy_rules = add_fuzzy_rule(fuzzy_rules, "Medium","Medium","High");
fuzzy_rules = add_fuzzy_rule(fuzzy_rules, "Medium","Bright","High");
fuzzy_rules = add_fuzzy_rule(fuzzy_rules, "Medium","VeryBright","VeryHigh");

fuzzy_rules = add_fuzzy_rule(fuzzy_rules, "Thick","VeryDark","VeryHigh");
fuzzy_rules = add_fuzzy_rule(fuzzy_rules, "Thick","Dark","VeryHigh");
fuzzy_rules = add_fuzzy_rule(fuzzy_rules, "Thick","Medium","VeryHigh");
fuzzy_rules = add_fuzzy_rule(fuzzy_rules, "Thick","Bright","VeryHigh");
fuzzy_rules = add_fuzzy_rule(fuzzy_rules, "Thick","VeryBright","VeryHigh");

for r = 1:size(fuzzy_rules, 1)
  fog_density_membership_value = fog_density_membership_function...
                          (fuzzy_rules(r).fog_density, input_fog_density_value);
  light_level_membership_value = light_level_membership_function...
                          (fuzzy_rules(r).light_level, input_light_level_value);
  firing_strength(r,1) = min(fog_density_membership_value, light_level_membership_value);
endfor

defuzzified_brightness = sum(firing_strength .* [fuzzy_rules.output_mode]') / sum(firing_strength);
