function L = triangle9()
% triangle9 outputs the set of desired states Sdes for the following pattern
%
%     x
%   x x x
% x x x x x
%
% The pattern uses 9 agents and has 9 states in Sdes.
%
% Mario Coppola, 2018

%Corners
L(1, :) = [0 1 1 0 0 0 0 0];
L(2, :) = [0 0 0 0 0 0 1 1];

%Top
L(3, :) = [0 0 0 1 1 1 0 0];

% Bottom
L(4, :) = [1 1 1 0 0 0 1 1];

% Sides
L(5, :) = [0 1 1 1 1 1 0 0]; %Left
L(6, :) = [0 0 0 1 1 1 1 1]; %Right

% Middle
L(7, :) = [1 0 1 1 1 1 1 0];

%Bottom sides
L(8, :) = [1 1 1 0 0 0 1 0]; %Left
L(9, :) = [1 0 1 0 0 0 1 1]; %Right

end
