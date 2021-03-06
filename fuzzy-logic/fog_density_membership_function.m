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
## @deftypefn {} {@var{membership_value} =} fog_density_membership_function (@var{fuzzy_set}, @var{value})
##
## @seealso{}
## @end deftypefn

## Author: Watchanan <Watchanan@WATCHANAN-DELL>
## Created: 2017-12-13

function [membership_value] = fog_density_membership_function (fuzzy_set, value)
  global e;
  global FogDensity;
  
  if any(strcmp (FogDensity.fuzzy_sets, fuzzy_set))
    membership_value = trapezoidal_shaped(value, FogDensity.(fuzzy_set).params, e);
  else
    error ("Invalid fuzzy set of fog density membership functions\n");
  endif
endfunction
