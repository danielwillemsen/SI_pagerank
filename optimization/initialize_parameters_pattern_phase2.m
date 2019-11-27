function [ga, s] = initialize_parameters_pattern_phase2(pattern_name, generations_max, n)

% GA Parameters
ga.fitness_function = @fitness_pattern_phase2; % Fitness function handle
ga.mutation_rate = 0.1; % Mutation rate
% Population breakdown (the three values below must sum up to 1)
ga.elite = 0.3; % Percentage of population that is elite
ga.parents = 0.4; % Percentage of population that reproduces
ga.mutate = 0.3; % Percentage of population that mutates
ga.generations_max = generations_max; % Maximum Generations
ga.max_trials = inf; % Maximum reproduction/mutation trials before giving up

% States parameters
linkset_des = feval(pattern_name); % Desired states
s.action_state_relation_idx = 1:8; % Use 1:8 for full action space
if nargin < 3
    s.n_agents = size(linkset_des, 1); % Number of agents in the swarm
else
    s.n_agents = n;
end

% Generate the initial Q matrix
[Q0, s.des, ~, ~, s.link_list] = init_policy_pattern (linkset_des, 0, s.action_state_relation_idx, 'n_agents', s.n_agents);
[s.mm, s.pm] = get_match_matrix_full();
states_kept = get_local_state_id(s.link_list);
s.mm = s.mm(states_kept, states_kept); % Match Matrix
s.pm = s.pm(states_kept, states_kept); % Direction Matrix
s.states = 1:size(Q0, 1);
s.simplicial = find_simplicial(s.link_list(1:end - 1, :));
s.static_0 = s.states(~ any(Q0, 2));
s.des_importance = ones(size(s.des)); % Default

end
