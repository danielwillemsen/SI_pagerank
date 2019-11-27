function [action_idx, possibleactions] = block_animation_selectaction(Q, state_idx)
% block_animation_selectaction selects an action to pursue from the given policy.
% If the cumulative probability of all actions is below 1, then the remainder is the probability of not taking any of the actions.
%
% Mario Coppola, 2018

possibleactions = find(abs(Q(state_idx, :)) > 0);
actionprobabilities = Q(state_idx, possibleactions);

if sum(actionprobabilities) >= 1.0
    actionprobabilities = actionprobabilities ./ sum(actionprobabilities);
elseif sum(actionprobabilities) < 1.0
    actionprobabilities(end + 1) = 1 - sum(actionprobabilities);
    possibleactions(end + 1) = 0;
end

action_idx = rand_from_vector(possibleactions, 1, actionprobabilities);

end
