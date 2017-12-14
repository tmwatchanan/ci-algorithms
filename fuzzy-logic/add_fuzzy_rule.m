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
## @deftypefn {} {@var{retval} =} add_fuzzy_rule (@var{fuzzy_rules},...
## @var{input_fuzzy_set_1}, @var{input_fuzzy_set_2}, @var{output_fuzzy_set})
##
## @seealso{}
## @end deftypefn

## Author: Watchanan <Watchanan@WATCHANAN-DELL>
## Created: 2017-12-14

function [fuzzy_rules] = add_fuzzy_rule (fuzzy_rules, input_fuzzy_set_1,...
                    input_fuzzy_set_2, output_fuzzy_set)
                    
  global Brightness;
  output_fuzzy_set_mode = Brightness.(output_fuzzy_set).mode;
  
  new_rule_struct = struct ("fog_density", input_fuzzy_set_1, "light_level", input_fuzzy_set_2,...
                            "brightness", output_fuzzy_set, "output_mode", output_fuzzy_set_mode);
  fuzzy_rules = [fuzzy_rules; new_rule_struct];
endfunction
