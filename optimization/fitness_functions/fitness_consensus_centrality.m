function [fitness,c,gs1] = fitness_consensus_centrality(Q, s)
% fitness_consensus_centrality computes the fitness function for the consensus task
% 
% Mario Coppola, 2018

gs1 = gs1_consensus(Q,s.states);
H = adjacency(gs1,'weighted'); % Generate H matrix as adjacency matrix of GS1
[D,E] = pr_DE_consensus(s);

alpha_v = sum(Q,2)./(s.n_neighbors+1); % Variable based on neighborhood
alpha_mat = diag(alpha_v); % Create matrix from alpha_v

c = pagerank(H,alpha_mat,0,D,E); % Calculate PageRank vector

fitness = mean(c(s.des))/mean(c);

end
