function [out, G] = reach_graph(states, transitions, states_inquired, states_des)
%reach_graph Determines whether the desired state can all be reached from all states by local transitions.
%
% Mario Coppola, 2018

if numel(states) ~= numel(transitions)
    error('States and transitions should be the same size')
end

G = transition_to_graph(transitions, states);

reach = cell(1, numel(states_inquired));
a = ones(1, numel(states_des));
states_inquired = unique(states_inquired);

out = 0; % Negative assumption. Some local states cannot be reached from all states

% If the graph is not connected then it's not ok.
if ~conncomp(G, 'Type', 'weak')
    return;
end

% If the graph has less nodes than inquired it's not ok.
if size(G.Nodes) < numel(states_inquired)
    return;
end

yes = zeros(1, numel(states_inquired));
for i = 1:numel(states_inquired)
    reach{i} = unique(bfsearch(G, states_inquired(i)));
    yes(i) = all(ismember(states_des, reach{i}));
    a = and(a, ismember(states_des, reach{i}));
end

if all(yes) % All desired states can be reached from all states
    out = 1;
end

end
