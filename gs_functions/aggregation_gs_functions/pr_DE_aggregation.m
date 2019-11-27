function [D,E] = pr_DE_aggregation(s)
% D and E matrices to model impact of GS2 and GS3 combined for the aggregation task
% D models the random impact on the dangling nodes (only static states)

E = adjacency(s.gs2,'weighted');
E = E./sum(E,2); % Normalize 

D = E;
st = s.states;
D(~ismember(st,s.des),:) = 0;

end

