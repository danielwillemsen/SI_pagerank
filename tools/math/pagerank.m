function [pr, i] = pagerank(H, alpha, v, D, E)
%pagerank computes the PageRank vector for an n-by-n Markov
% matrix H with starting vector pi0 (a row vector),
% scaling parameter alpha (scalar), and teleportation
% vector v (a row vector). Uses power method.
%
% EXAMPLE:[pr,iterations]=pagerank(H,alpha,1e-8,v);
%
% INPUT:
%   H     = row-normalized hyperlink matrix (n-by-n sparse matrix)
%   alpha = follow probability, scalar scaling parameter in PageRank model (scalar),
%   v     = teleportation vector (1-by-n row vector)
%   D     = Dangling node matrix
%   E     = Teleportation matrix (can be defined instead of v)
%
% OUTPUT:
%   pr = PageRank vector
%   i  = Number of iterations
%
% Adapted from Langville et al., Google's PageRank and beyond, 2006
%
% Mario Coppola, 2018

% The starting vector is usually set to the uniform vector,
n = size(H, 1);
pr_0 = 1 / n * ones(1, n);

% Make sure H is normalized
H = H ./ sum(H, 2);
H(isnan(H)) = 0;

% Personalization vector default
if nargin < 3
    v = 1 / n * ones(n, 1);
    % Get "a" vector, where a(i)=1, if row i is dangling node and 0
    rowsumvector = ones(1, n) * H';
    nonzerorows = find(rowsumvector);
    zerorows = setdiff(1:n, nonzerorows);
    l = length(zerorows);
    a = sparse(zerorows, ones(l, 1), ones(l, 1), n, 1);
end

% Divide two terms
if nargin <= 3
    D = a * v';        % Dangling node teleportation matrix
    E = ones(1, n) * v; % Teleportation matrix
end

% Check if G is primitive
G = alpha * (H + D) + (eye(size(alpha)) - alpha) * (E);
if abs(max(eig(G)) - 1) > 1e-8
    warning('G may not be primitive. Convergence may by slow.')
end

% Iterative procedure
i = 0; % Counter
pr = pr_0; % Pagerank
residual = 1; % Residual (initialize high, doesn't really matter)
tol = 1e-8; % Convergence tolerance (scalar, e.g. 1e-8)
while residual >= tol
    i = i + 1;
    pr_previous = pr;
    % The following two are equivalent. One is the one from the book
    % the other one is just organized such that the random and follow items
    % are more clearly separated into terms 1 and 2.
 
    % Simplified expression from Langville
    % pr = alpha * pr * H + ( alpha * (pr*a) + 1 - alpha) * v';
 
    % Calculate the Pagerank, pr = pr * G
    pr = pr * (alpha * (H + D) + (eye(size(alpha)) - alpha) * E);
 
    residual = norm (pr - pr_previous, 1);
end

end
