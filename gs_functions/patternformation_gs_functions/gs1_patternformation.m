function [tgs1, tgs1r, action_used, action_used_r] = gs1_patternformation(s, Q, act_state, link_list)
% gs1_patternformation Calculates the local graph GS1, which is defined as:
% GS1 : indicates all state transitions that a robot could go through by an action of its own the policy Πf.
%
% Mario Coppola, 2018

statespace = statespace_grid;
actionspace = statespace(act_state, :);
possibleactions = find(Q(s, :) > 0);
tgs1 = [];
tgs1r = [];
action_used = [];
action_used_r = zeros(1, length(possibleactions));

for i = 1:length(possibleactions)
    action_idx = possibleactions(i);
    action = actionspace(action_idx, :);
    statespace_local = statespace;
    statespace_local(link_list(s, :) == 0, :) = []; % neighbors
    newpos = statespace_local - action;
    ppv = statespace;
    [~, idx] = ismember(newpos, ppv, 'rows');
    idx(idx == 0) = [];
    new_link = zeros(1, 8);
    new_link(idx) = 1;
 
    % use new_link_known to explain what the agent could find the new environment
    a = act_state(action_idx);
    if sum(abs(action)) > 1.1 % Diagonal action (1.1 instead of 1 to avoid rounding)
        new_link_known = wraptosequence (a + 4 - 1:a + 4 + 1, [1 size(statespace, 1)]);
    else % Horizontal action
        new_link_known = wraptosequence (a + 4 - 2:a + 4 + 2, [1 size(statespace, 1)]);
    end
    new_link_not_known = setdiff(1:8, new_link_known);
 
    length_unknown = 8 - numel(new_link_known);
    whathecanfind = dec2bin(0:2 ^ length_unknown - 1, length_unknown) - '0';
    whatheknowns = new_link(new_link_known);
    new_link = zeros(size(whathecanfind, 1), 8);
    t = repmat(whatheknowns, size(whathecanfind, 1), 1);
    new_link(:, new_link_known) = t;
    new_link(:, new_link_not_known) = whathecanfind;
 
    newlinks = get_local_state_id(new_link);
 
    % Remap
    s_id_orig = get_local_state_id(link_list);
    newlinks = find(ismember(s_id_orig, newlinks));
 
    tgs1 = [tgs1 newlinks];
    tgs1r = [tgs1r newlinks(1)];
    action_used = [action_used repmat(action_idx, 1, numel(newlinks))];
    action_used_r(i) = action_idx;
end

end
