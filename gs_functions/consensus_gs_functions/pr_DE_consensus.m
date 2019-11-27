function [D,E] = pr_DE_consensus(s)
% D and E matrices to model impact of GS2 and GS3 combined
% D models the random impact on the dangling nodes (only static states)

nstates = size(s.states, 1);
D = zeros(nstates,nstates);
for i = 1:numel(s.des)
    D(s.des(i),s.tgs2{s.des(i)}) = 1/numel(s.tgs2{s.des(i)});
end

% E models the random impact on all nodes (all states)
E = zeros(nstates,nstates);
for i = 1:nstates
    E(i,s.tgs2{i}) = 1/numel(s.tgs2{i});
end

end

