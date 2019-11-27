function L = triangle4()
% triangle4 outputs the set of desired states Sdes for the following pattern
%
%    x
%  x x x
%
% The pattern uses 4 agents and has 4 states in Sdes.
%
% Mario Coppola, 2018

L(1, :) = [0 1 1 0 0 0 0 0];
L(2, :) = [0 0 0 1 1 1 0 0];
L(4, :) = [1 0 1 0 0 0 1 0];
L(3, :) = [0 0 0 0 0 0 1 1];

end
