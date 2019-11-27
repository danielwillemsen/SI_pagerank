function [possibledirections] = get_possibleactions(l, varargin)
%get_possibleactions For a given local state, this provides the possible directions that the agent can move in 
% (i.e., the possible actions)
%
% Mario Coppola, 2018

% Select actions that don't lead to collisions
possibledirections = find(l == 0);

% Delete actions that cause separation
del = [];
for i = 1:length(possibledirections)
    statespace_local = statespace_grid;
    statespace_local(l == 0, :) = []; % leave only neighbors
 
    actionspace = statespace_grid; % Actionspace = statespace
    newarrangement = [statespace_local; actionspace(possibledirections(i), :)];
 
    % Check if one agent is left alone
    flag = 0;
    for j = 1:size(newarrangement, 1)
        if all(max(abs([newarrangement(j, 1) newarrangement(j, 2)] - newarrangement([1:j - 1, j + 1:end], :)), [], 2) > 1)
            del = [del i];
            flag = 1;
            break;
        end
    end
    if flag
        continue;
    end
 
    % Check if group splits in subgroups
    dar = diff(sort(newarrangement), 1);
    if any(dar(:) > 1)
        del = [del i];
        continue;
    end
 
end
possibledirections(unique(del)) = [];

end
