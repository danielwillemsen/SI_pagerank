function [ state_idx_local, L ] = model_pattern_local( state_global )
% model_pattern_local takes in a global set of states (positions on the 2D grid)
% and translates this to the local states of the agents
%
% Mario Coppola, 2018

statespace_local = statespace_grid;
state_idx_local = zeros(size(state_global,1),1);
L = zeros(size(state_global,1),8);

for i = 1:size(state_global,1)
    state_global_centered = state_global-(state_global(i,:));
    state_global_centered(i,:) = [];
    state_global_centered(mag(state_global_centered,'row')>(sqrt(2)+0.1),:) = [];
    [~,idx] = ismember(state_global_centered,statespace_local,'rows');
    idx(idx==0) = [];        
    L(i,idx) = 1;
    state_idx_local(i) = get_local_state_id(L(i,:));
end

% Empty state (no agents around)
state_idx_local(state_idx_local==0) = 256;

end