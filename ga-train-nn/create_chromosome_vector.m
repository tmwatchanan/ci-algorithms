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
## @deftypefn {} {@var{chromosome_prototype} =} create_chromosome_vector (@var{weights}, @var{num_layers})
##
## @seealso{}
## @end deftypefn

## Author: Watchanan <Watchanan@WATCHANAN-DELL>
## Created: 2017-12-10

function chromosome_prototype = create_chromosome_vector (weights, num_layers)
  chromosome_prototype = [];
  for layer = num_layers:-1:2
    chromosome_prototype = [chromosome_prototype reshape(weights{layer},1,[])(end:-1:1)];
  endfor
endfunction
