function s = statespace_grid
%statespace_grid Holds the enconding of local statespace for neighboring positions 1 to 8
%
%   8  1  2 
%    \ | /
%   7- o -3
%	 / | \
%   6  5  4
%
% Mario Coppola, 2018

s = [0 1; 1 1; 1 0; 1 -1; 0 -1; -1 -1; -1 0; -1 1];

end
