function L = hexagon()
% hexagon outputs the set of desired states Sdes for the following pattern
%
%   x
% x   x
% x   x
%   x
%
% The pattern uses 6 agents and has 6 states in Sdes.
%
% Mario Coppola, 2018

L(1, :) = [1 0 0 1 0 0 0 0];
L(2, :) = [0 1 0 0 0 0 0 1];
L(3, :) = [1 0 0 0 0 1 0 0];
L(4, :) = [0 0 0 0 1 0 0 1];
L(5, :) = [0 0 0 1 0 1 0 0];
L(6, :) = [0 1 0 0 1 0 0 0];

end
