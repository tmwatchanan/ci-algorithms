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
## @deftypefn {} {@var{retval} =} trapezoidal_shaped (@var{x}, @var{[a,b,c,d]}, @var{e})
##
## @seealso{}
## @end deftypefn

## Author: Watchanan <Watchanan@WATCHANAN-DELL>
## Created: 2017-12-13

function [f] = trapezoidal_shaped (x, [a,b,c,d], e)
  if (a <= x && x <= b)
    f = ((a - x) * e) / (a - b);
  elseif (b <= x && x <= c)
    f = e;
  elseif (c <= x && x <= d)
    f = ((d - x) * e) / (d - c);
  else
    f = 0;
  endif
endfunction
