function [fitness,c,gs1] = fitness_pattern_centrality(Q, s, tgs1, tgs1_a, tgs2, tgs3)
% fitness_consensus_centrality computes the fitness function for the patternformation task
% 
% Mario Coppola, 2018

% Fitness centrality calculation
Qcell = mat2cell(Q, ones(1,size(Q,1)), size(Q,2))'; % Make cells of Q
t     = cellfun(@(x,y) y(x), tgs1_a, Qcell, 'UniformOutput', false); % Create transitions
gs1   = transition_to_graph(tgs1, s.states, t); % Generate GS1
n     = size(gs1.Nodes,1); % Total number of nodes

% Union of GS2 and GS3 for computing D and E
tgs23 = cell(1,n);
for i = 1:numel(tgs2)
    tgs23{i} = union(tgs2{i},tgs3{i});
end

% D and E matrices to model impact of GS2 and GS3 combined
% D models the random impact on the dangling nodes (only static states)
D = zeros(n,n);
for i = 1:numel(s.static)
    D(s.static(i),tgs23{s.static(i)}) = 1/numel(tgs23{s.static(i)});
end
% E models the random impact on all nodes (all states)
E = zeros(n,n);
for i = 1:numel(s.states)
    E(s.states(i),tgs23{s.states(i)}) = 1/numel(tgs23{s.states(i)});
end

H = adjacency(gs1,'weighted'); % Generate H matrix as adjacency matrix of GS1

% Follow probability vector, uncomment one below depending on preference
n_neighbors = sum(s.link_list,2);
alpha_v = 1./(n_neighbors+1); % variable based on neighborhood
alpha_v = alpha_v .* sum(Q,2); %TODO: DISCREPANCY IN DATA
alpha_mat = diag(alpha_v); % Create matrix from alpha_v

c = pagerank(H,alpha_mat,0,D,E); % Calculate PageRank vector

fitness = (sum(c(s.des).*s.des_importance)/sum(s.des_importance))/mean(c);

end
