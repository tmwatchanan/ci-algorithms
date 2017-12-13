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
## @deftypefn {} {@var{membership_value} =} light_level_membership_function (@var{fuzzy_set}, @var{value})
##
## @seealso{}
## @end deftypefn

## Author: Watchanan <Watchanan@WATCHANAN-DELL>
## Created: 2017-12-14

function [membership_value] = light_level_membership_function (fuzzy_set, value)
  global e;
  global VeryDark_params;
  global Dark_params;
  global Medium_params;
  global Bright_params;
  global VeryBright_params;
  
  if strcmp(fuzzy_set, "very_dark")
    membership_value = trapezoidal_shaped(value, VeryDark_params, e);
  elseif strcmp(fuzzy_set, "dark")
    membership_value = trapezoidal_shaped(value, Dark_params, e);
  elseif strcmp(fuzzy_set, "medium")
    membership_value = trapezoidal_shaped(value, Medium_params, e);
  elseif strcmp(fuzzy_set, "bright")
    membership_value = trapezoidal_shaped(value, Bright_params, e);
  elseif strcmp(fuzzy_set, "very_bright")
    membership_value = trapezoidal_shaped(value, VeryBright_params, e);
  else
    error ("Invalid fuzzy set of light level membership functions\n");
  endif
endfunction
