# Adaptive Brightness System for Outdoor Display using Fuzzy Control
I did implement the fuzzy control system used for adaptive brightness outdoor display. This fuzzy control is based on the Mamdani model.

## Inputs and Outputs
I consider fog density and environment light level as the inputs. Obviously, the output must be brightness of the outdoor screen.
Thus, the inputs of the system are consist of `LWC (g/m^3)` for fog density and `illuminance (lux)` for light level. On the other hand, the output is in the form of `brightness (%)`.

## Membership Functions
### Fog Density Fuzzy Sets
![Fog Density Fuzzy Sets](https://github.com/tmwatchanan/ci-algorithms/blob/master/fuzzy-logic/figures/membership_function_fog_density_fuzzy_sets.png)
### Environment Light Level Fuzzy Sets
![Environment Light Level Fuzzy Sets](https://github.com/tmwatchanan/ci-algorithms/blob/master/fuzzy-logic/figures/membership_function_light_level_fuzzy_sets.png)
### Screen Brightness Fuzzy Sets
![Screen Brightness Fuzzy Sets](https://github.com/tmwatchanan/ci-algorithms/blob/master/fuzzy-logic/figures/membership_function_screen_brightness_fuzzy_sets.png)

## Fuzzy Rules
![fuzzy rules](https://github.com/tmwatchanan/ci-algorithms/blob/master/fuzzy-logic/figures/adaptive_brightness_display-fuzzy_rules.png)
