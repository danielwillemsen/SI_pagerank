function G = transition_to_graph(t, states, weights)
%transition_to_graph Given a set of transitions, states, and weights, generates a graph G 
%
% Mario Coppola, 2018

emptycells = cellfun(@isempty, t);
startingpoints = states(~ emptycells);
t = t(~ emptycells);
cellsize = cell2mat(cellfun(@length, t, 'uni', false));
allstartingpoints = rude(cellsize, startingpoints);
alltransitions = cat(2, t{:});
alledges = [allstartingpoints',alltransitions'];

if nargin < 3
    % Compute graph G (not weighted)
    G = digraph(double(alledges(:, 1)), double(alledges(:, 2)));
else
    % Compute graph G (weighted)
    G = digraph(double(alledges(:, 1)), double(alledges(:, 2)), double(cat(2, weights{:})));
end

% Make sure the number of nodes stays constant
if max(max(alledges)) < numel(states)
    extra = max(max(alledges)) + 1:numel(states);
    G = addnode(G, numel(extra)); % add the extra nodes (no inlinks or outlinks)
end

G = simplify(G); % Strip of double edges

end
