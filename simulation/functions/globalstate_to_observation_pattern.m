function [state_local] = globalstate_to_observation_pattern(param, state_global)
%globalstate_to_observation takes as input a global state (pattern and positions of agents) and outputs the local states of the agent.
%
% Mario Coppola, 2018

if ~ isempty(param.observation)
    state_local = param.observation (state_global);
else
    state_local = state_global_n;
end

end
