function [match_matrix, position_match_matrix] = calculate_match_matrix (link_set, varargin)

verbose = checkifparameterpresent(varargin, 'verbose', 0, 'array');
active = checkifparameterpresent(varargin, 'active', ones(1, size(link_set, 2)), 'array');

if any(exist('match_matrix_allstates.mat', 'file')) && all(active)
    s = get_local_state_id(link_set);
    [match_matrix_full, position_match_matrix_full] = get_match_matrix_full('verbose', verbose);
    match_matrix = match_matrix_full(s, :);
    match_matrix = match_matrix(:, s);
    position_match_matrix = position_match_matrix_full(s, :);
    position_match_matrix = position_match_matrix(:, s);
 
else
 
    if verbose
        disp('Computing match matrix')
    end
 
    match_matrix = zeros(size(link_set, 1));
    position_match_matrix = cell(size(link_set, 1));
    position_match_matrix = cellfun(@uint8, position_match_matrix, 'UniformOutput', 0);
    for i = 1:size(link_set, 1) % Select link 1
        for j = 1:size(link_set, 1) % Select link 2
            for d = 1:size(link_set, 2) % Go around the circle
                if check_link_validity_general(link_set(i, :), link_set(j, :), d, 'active', active)
                    match_matrix(i, j) = match_matrix(i, j) + 1;
                    position_match_matrix{i, j} = [position_match_matrix{i, j} uint8(d)];
                end
            end
        end
    end
 
    if ~issymmetric(match_matrix)
        warning('Ln matrix is not symmetric.')
    end
end

match_matrix = uint8(match_matrix);

end
