function [ state_global_n ] = model_pattern_global( state_global, action_idx )
%model_pattern_global simulates the effect of a local action on the global state of the swarm.
%
% Mario Coppola, 2018

actionspace    = [statespace_grid; 0 0]; % actionspace = statespace + no motion
state_global_n = state_global + actionspace(action_idx,:);

end