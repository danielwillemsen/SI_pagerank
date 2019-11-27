function [fitness,c,gs1] = fitness_consensus_binary_centrality(Q, s)
% fitness_consensus_binary_centrality computes the fitness function for the consensus task (binary variant)
% 
% Mario Coppola, 2018

gs1 = gs1_consensus_binary(Q,s.states);
H = adjacency(gs1,'weighted'); % Generate H matrix as adjacency matrix of GS1
[D,E] = pr_DE_consensus_binary(s);
alpha_v = 0.3*ones(size(D,1),1);
alpha_mat = diag(alpha_v); % Create matrix from alpha_v
c = pagerank(H,alpha_mat,0,D,E); % Calculate PageRank vector

% select one of them
fitness = mean(c(s.des))/mean(c); % unbiased
% fitness = mean(c(s.des(1)))/mean(c); % bias towards A
% fitness = mean(c(s.des(2)))/mean(c); % bias towards B

end
