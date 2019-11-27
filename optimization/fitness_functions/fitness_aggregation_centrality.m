function [fitness,c,gs1] = fitness_aggregation_centrality(Q, s)
% fitness_aggregation_centrality computes the fitness function for the aggregation task
% 
% Mario Coppola, 2018
gs1 = gs1_aggregation(Q,s);
H = adjacency(gs1,'weighted'); % Generate H matrix as adjacency matrix of GS1

s.gs2 = gs2_aggregation(Q,s);
[D,E] = pr_DE_aggregation(s);

% Follow probability vector, uncomment one below depending on preference
% keyboard
alpha_v = ones(size(D,1),1).*sum(Q,2)./(s.states)';% At all times the swarm is equally subject to itself and its environment.
alpha_mat = diag(alpha_v); % Create matrix from alpha_v

c = pagerank(H,alpha_mat,0,D,E); % Calculate PageRank vector
fitness = mean(c(3:end))/mean(c);

end
