function [link_set] = delete_unmatchables(link_set, varargin)

verbose = checkifparameterpresent(varargin, 'verbose', 0, 'number');
n_agents = checkifparameterpresent(varargin, 'n_agents', size(link_set, 1), 'array');
active = checkifparameterpresent(varargin, 'active', ones(1, size(link_set, 2)), 'array');

oldsizeL = 1;
newsizeL = 2;
while oldsizeL ~= newsizeL % Run many times to update with deleted links
    oldsizeL = size(link_set, 1);
    mm = calculate_match_matrix(link_set, 'n_agents', n_agents, 'active', active, 'verbose', 0);
    link_set(sum(mm, 2) == 0, :) = [];
    newsizeL = size(link_set, 1);
end

if verbose
    disp(['Deleted unmatchables: ', num2str(newsizeL)])
end

end
