function state_global_0 = make_random_initial_pattern(n_agents)
% make_state_global_t0 creates an initial random configuration, with
% a connected topology
%
% Mario Coppola, 2018

% Keep adding points until we have n points (i.e. positions of n agents)
statespace = statespace_grid;
state_global_0 = zeros(n_agents, 2);
i = 2;
while i <= n_agents
    t = 0;
    while true
        state_global_0(i, :) = state_global_0(i - 1, :) + statespace(randi(8), :);
        if size(unique(state_global_0(1:i, :), 'rows'), 1) == i
            break;
        else
            t = t + 1;
        end
     
        if t > 10
            i = i - 1;
            t = 0;
        end
    end
    i = i + 1;
end

end
