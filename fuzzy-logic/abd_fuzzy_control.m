## Copyright (C) 2017 Watchanan
## 
## This program is free software; you can redistribute it and/or modify it
## under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 3 of the License, or
## (at your option) any later version.
## 
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
## 
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see <http://www.gnu.org/licenses/>.

## -*- texinfo -*- 
## @deftypefn {} {@var{defuzzified_brightness} =} abd_fuzzy_control (@var{input_fog_density_value}, @var{input_light_level_value})
##
## @seealso{}
## @end deftypefn

## Author: Watchanan <Watchanan@WATCHANAN-DELL>
## Created: 2017-12-14

function [defuzzified_brightness] = abd_fuzzy_control (input_fog_density_value, input_light_level_value)
  global fuzzy_rules;
  
  firing_strength = zeros(size(fuzzy_rules, 1), 1);
  for r = 1:size(fuzzy_rules, 1)
    fog_density_membership_value = fog_density_membership_function...
                            (fuzzy_rules(r).fog_density, input_fog_density_value);
    light_level_membership_value = light_level_membership_function...
                            (fuzzy_rules(r).light_level, input_light_level_value);
    firing_strength(r,1) = min(fog_density_membership_value, light_level_membership_value);
  endfor

  if (sum(firing_strength) == 0)
    defuzzified_brightness = 0;
  else
    defuzzified_brightness = sum(firing_strength .* [fuzzy_rules.output_mode]') / sum(firing_strength);
  endif
endfunction
