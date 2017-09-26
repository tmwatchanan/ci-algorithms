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
## @deftypefn {} {@var{retval} =} KFold (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: Watchanan <Watchanan@DELL-INSPIRON-3>
## Created: 2017-09-25

function [training_sets, test_sets] = KFold (data, k)
  % Shuffle the data
  data = data(randperm(size(data,1)), :);
  % #samples of the data
  N = size(data, 1);
  fold_size = N / k;
  for i = 1:k
    data_tmp = data;
    training_set_indices = ((i-1) * fold_size)+1:(i * fold_size);
    training_sets{i} = data_tmp(training_set_indices, :);
    data_tmp(training_set_indices, :) = [];
    test_sets{i} = data_tmp;
  endfor
endfunction
