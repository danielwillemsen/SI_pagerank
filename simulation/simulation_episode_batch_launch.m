function stats = simulation_episode_batch_launch(sml, Q, episodes, varargin)
% simulation_episode_batch_launch is a function to run several simulation episodes together
% for a given policy
%
% Mario Coppola, 2018

type = checkifparameterpresent(varargin, 'type', 'pattern', 'string');
visualize = checkifparameterpresent(varargin, 'visualize', 0, 'array');
verbose = checkifparameterpresent(varargin, 'verbose', 0, 'array');

stats.n_episodes = 0;

for i = 1:episodes
    stats.n_episodes = stats.n_episodes + 1;
    
    if strcmp(type,'pattern') % Default
        sml.observation = @model_pattern_local;
        sml.model = @model_pattern_global;
        state_global_0 = make_state_global_t0(sml, sml.n_agents); % Make a random initial condition
        tic
        stats.n_steps(stats.n_episodes) = simulation_episode_pattern(sml, state_global_0, Q, 'visualize', visualize);
        stats.ev_time(stats.n_episodes) = toc;
    elseif strcmp(type,'consensus')
        state_global_0 = make_random_initial_pattern(sml.n_agents);
        tic
        stats.n_steps(stats.n_episodes) = simulation_episode_consensus(sml, state_global_0, Q, 'visualize', visualize);
        stats.ev_time(stats.n_episodes) = toc;
    elseif strcmp(type,'consensus_binary')
        state_global_0 = make_random_initial_pattern(sml.n_agents);
        tic
        stats.n_steps(stats.n_episodes) = simulation_episode_consensus_binary(sml, state_global_0, Q, 'visualize', visualize);
        stats.ev_time(stats.n_episodes) = toc;
    end
    
    if verbose
        fprintf('\n Episode %d \t Number of steps = %d', stats.n_episodes, stats.n_steps(stats.n_episodes))
    end
    
end

end
