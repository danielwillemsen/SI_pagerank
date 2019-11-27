function L = T
% T outputs the set of desired states Sdes for the following pattern
%
%  x x x x
%  x x x x
%    x x
%    x x
%
% The pattern uses 12 agents and has 11 states in Sdes.
%
% Mario Coppola, 2018

L(1, :) = [1 1 1 0 0 0 0 0];
L(2, :) = [1 1 1 1 0 0 0 0];
L(3, :) = [0 0 1 1 1 0 0 0];
L(4, :) = [0 0 0 0 1 1 1 0];
L(5, :) = [1 0 0 0 0 1 1 1];
L(6, :) = [1 0 0 0 0 0 1 1];

L(7, :) = [0 0 1 1 1 1 1 0];
L(8, :) = [1 1 1 1 1 0 1 1];
L(9, :) = [1 1 1 0 1 1 1 1];

L(10, :) = [1 1 1 1 1 0 0 1];
L(11, :) = [1 1 0 0 1 1 1 1];

end
