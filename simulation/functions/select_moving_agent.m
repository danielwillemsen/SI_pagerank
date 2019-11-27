function [selected_agent, agents_that_can_move] = select_moving_agent(Q, state_local, selected_agent_last_step)
%select_moving_agent Selects the agent that will move in the simulation.
% This is chosen following a uniform distribution, whereby the agent that moved last is exluded 
% so as to simulate that it will stop after an action and leave time for neighbors to move.
%
% Mario Coppola, 2018

% Full randomness
[selected_rows, ~] = find(Q(state_local, :) > 0);
agents_that_can_move = unique(selected_rows);

% Do not repeat agents
if length(agents_that_can_move) > 1
    agents_that_can_move(agents_that_can_move == selected_agent_last_step) = [];
end

% Select agent
selected_agent = rand_from_vector(agents_that_can_move, 1);

if isempty(selected_agent)
    selected_agent = 0;
end

end
