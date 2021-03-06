function y = weighted_mean(x, w, dim)
%weighted_mean Weighted Average or mean value.
%   For vectors, WMEAN(X,W) is the weighted mean value of the elements in X
%   using non-negative weights W. For matrices, WMEAN(X,W) is a row vector
%   containing the weighted mean value of each column.  For N-D arrays,
%   WMEAN(X,W) is the weighted mean value of the elements along the first
%   non-singleton dimension of X.
%
%   Each element of X requires a corresponding weight, and hence the size
%   of W must match that of X.
%
%   WMEAN(X,W,DIM) takes the weighted mean along the dimension DIM of X.
%
%   Class support for inputs X and W:
%      float: double, single
%
%   Example:
%       x = rand(5,2);
%       w = rand(5,2);
%       wmean(x,w)

if nargin < 2
    error('Not enough input arguments.');
end

% Check that all of W are non-negative.
if any(w(:) < 0)
    error('All weights, W, must be non-negative.');
end

% Check that there is at least one non-zero weight.
if all(w(:) == 0)
    error('At least one weight must be non-zero.');
end

if nargin == 2
    % Determine which dimension SUM will use
    dim = min(find(size(x) ~= 1));
    if isempty(dim)
        dim = 1;
    end
end

y = sum(w .* x, dim) ./ sum(w, dim);

end
