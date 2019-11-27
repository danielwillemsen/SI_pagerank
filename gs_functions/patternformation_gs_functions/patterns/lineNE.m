function L = lineNE
% lineNE outputs the set of desired states Sdes for the following pattern
%
%           x
%         x
%       .
%     .
%   x
% x
%
% The pattern uses N agents and has 3 states in Sdes.
% Note that this pattern does not fulfill the contraints of Phase 1.
%
% Mario Coppola, 2018

L = zeros(3, 8);
p = 2;
L(1, p) = 1;
L(2, p + 4) = 1;
L(3, [p, p + 4]) = 1;

end
