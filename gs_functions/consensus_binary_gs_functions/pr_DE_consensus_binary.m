function [D,E] = pr_DE_consensus_binary(s)
% D and E matrices to model impact of GS2 and GS3 combined
% D models the random impact on the dangling nodes (only static states)

% E models the random impact on all nodes (all states)
E = adjacency(s.gs2,'weighted');

D = E;
D(1:2:numel(s.states(:,1)),:) = 0;

end

