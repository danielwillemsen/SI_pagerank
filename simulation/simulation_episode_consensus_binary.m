function action_steps = simulation_episode_consensus_binary(sml, pattern, Q, varargin)
% simulation_episode_consensus_binary perform one simulation episode of the task for a given policy Q and returns the number of actions taken.
%
% Mario Coppola, 2019

visualize = checkifparameterpresent(varargin, 'visualize', 0, 'array');

n_steps = 0;
selected_agent = 0;

action_steps = 0;

s0_l = 0;
while range(s0_l) == 0.
    s0_l = randi([1 sml.bw],sml.n_agents,1);
end

[state_local,state_local_full] = globalstate_to_observation_consensus_binary(s0_l, sml.states, sml, pattern);

while action_steps < inf
    
    n_steps = n_steps + 1;
    s0_l = state_local_full(:,1);
    selected_agent = select_moving_agent(Q, state_local, selected_agent);
    
    if selected_agent > 0 % If someone can move
        actionprobabilities = Q(state_local(selected_agent),:);
        actionprobabilities = actionprobabilities ./ sum(actionprobabilities);
        s0_l(selected_agent) = rand_from_vector(1:sml.bw, 1, actionprobabilities);
        
        action_steps = action_steps + 1;
        [state_local,state_local_full] = globalstate_to_observation_consensus_binary(s0_l, sml.states, sml, pattern);
        
        if visualize
            plot_formation_consensus(sml.bw, state_local_full, pattern);
            drawnow;
        end
        
        if check_all_happy(sml, state_local)
            break;
        end
    end
    
end

end
