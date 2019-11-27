function [match_matrix, position_match_matrix, states] = get_match_matrix_full(varargin)

verbose = checkifparameterpresent(varargin, 'verbose', 0, 'number');

% Set up match matrix
states = 1:255;
if ~ any(exist('match_matrix_allstates.mat', 'file'))
    fprintf('Match-Matrix MAT file not found. Generating match matrix...\n This only needs to be done once. \n');
    link_list = dec2bin(states, 8) - '0';
    link_list = delete_unmatchables(link_list); % Delete states that cannot be matched to any other state at all
    link_list = delete_incompatible(link_list); % Delete states that cannot be matched along all directions
    [match_matrix, position_match_matrix] = calculate_match_matrix(link_list);
    save('match_matrix_allstates.mat', 'match_matrix', 'position_match_matrix');
    fprintf('Match-Matrix MAT file generated\n');
else
	% Since it can take quite a few seconds to generate a match matrix, just loading it is way faster.
    load('match_matrix_allstates.mat'); 
end

end


