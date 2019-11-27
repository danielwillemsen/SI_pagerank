function link_set = delete_incompatible(link_set, varargin)

% We can then look at whether all necessary directions are covered,
% otherwise we already know that it's impossible for an agent to connect
% with any of the other agents in the group.

verbose = checkifparameterpresent(varargin, 'verbose', 0, 'number');
n_agents = checkifparameterpresent(varargin, 'n_agents', size(link_set, 1), 'array');
active = checkifparameterpresent(varargin, 'active', ones(1, size(link_set, 2)), 'array');

oldsizeL = 1;
newsizeL = 2;
while oldsizeL ~= newsizeL % run many times to update with deleted links
    oldsizeL = size(link_set, 1);
    [~, pm] = calculate_match_matrix(link_set, 'n_agents', n_agents, 'active', active, 'verbose', 0);
    del = [];
    for i = 1:oldsizeL
        directionscovered = [];
        directionscovered = unique([directionscovered; pm{i, :}]);
        directionstocover = find(link_set(i, :) > 0);
        if ~ all(ismember(directionstocover, directionscovered))
            del = [del i];
        end
    end
    link_set(del, :) = [];
    newsizeL = size(link_set, 1);
end

if verbose
    disp(['Deleted incompatible: ', num2str(newsizeL)])
end

end
