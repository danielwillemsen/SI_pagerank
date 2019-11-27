function state_global_0 = make_state_global_t0(bsim, n_agents)
% make_state_global_t0 creates an initial random configuration, with
% a connected topology
%
% Mario Coppola, 2018

while true
    state_global_0 = make_random_initial_pattern(n_agents);
    state_local_0 = globalstate_to_observation_pattern(bsim, state_global_0);
    if ~ check_all_happy(bsim, state_local_0)
        break;
    end
end

end
