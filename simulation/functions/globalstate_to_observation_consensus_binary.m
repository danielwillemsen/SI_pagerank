function [state_idx_local,state_local] = globalstate_to_observation_consensus_binary(s0_l, states, sim, pattern)
%globalstate_to_observation takes as input a global state (pattern and positions of agents) and outputs the local states of the agent.
%
% Mario Coppola, 2018

state_global = [s0_l pattern];
for i = 1:numel(s0_l)
    state_global_centered = [s0_l state_global(:,[2 3])-(state_global(i,[2 3]))];
    state_global_centered(i,:) = [];
    state_global_centered(mag(state_global_centered(:,[2 3]),'row')>(sqrt(2)+0.1),:) = [];
    st = zeros(1,sim.bw);
    for j = 1:sim.bw
         st(j) = numel(find(state_global_centered(:,1) == j));
    end
    state_local(i,:) = [state_global(i,1) all(state_global_centered(:,1)==state_global(i,1))];
    [~, state_idx_local(i)] = ismember(state_local(i,:),states,'rows');
end

end
