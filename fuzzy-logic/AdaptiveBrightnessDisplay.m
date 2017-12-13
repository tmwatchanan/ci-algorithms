clear all;
close all;
global_configs;

input_fog_density_fuzzy_set = "thin";
input_fog_density_value = 0.03;
fog_density_membership_value = fog_density_membership_function (input_fog_density_fuzzy_set, input_fog_density_value)

input_brightness_fuzzy_set = "moderate";
input_brightness_value = 50;
brightness_membership_value = brightness_membership_function (input_brightness_fuzzy_set, input_brightness_value)

input_light_level_fuzzy_set = "bright";
input_light_level_value = 5000;
light_level_membership_value = light_level_membership_function (input_light_level_fuzzy_set, input_light_level_value)
