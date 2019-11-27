function [ga, s, Q0,fitness0] = initialize_parameters_pattern_phase1(pattern_name,generations_max, n_agents)

% GA Parameters
ga.fitness_function = @fitness_pattern_phase1; % Fitness function handle
ga.mutation_rate    = 0.3;    % Mutation rate (maximum, can be less)
% Population breakdown (the three values below must sum up to 1)
ga.elite = 0.3;    % Percentage of population that is elite 
ga.parents = 0.4;    % Percentage of population that reproduces
ga.mutants = 0.3;    % Percentage of population that mutates
ga.generations_max  = generations_max;   % GA maximum generations
ga.max_trials       = inf; % Maximum reproduction/mutation trials before giving up

% States parameters
linkset_des = feval(pattern_name);  % Desired states
s.action_state_relation_idx = 1:8;  % Actions are 1:8 for full action space in grid world
if nargin < 3
    s.n_agents = size(linkset_des,1); % Number of agents in the swarm. Based on desired states.
else
    s.n_agents = n_agents; % Use this from input if n_agents ~= number of desired states
end

% Build the state action map
[Q0, s.des, ~, ~, s.link_list] = init_policy_pattern ( ...
    linkset_des, 0, s.action_state_relation_idx, 'n_agents', s.n_agents);

% Extract states with certain properties
s.states         = 1:size(Q0,1); % Just all states
s.simplicial     = setdiff(find_simplicial(s.link_list(1:end,:)),255); % 255 doesn't count
s.static_0       = s.states(~any(Q0,2));
s.des_importance = ones(size(s.des));

% Get the match matrix and the direction matrix
[s.mm, s.pm]     = get_match_matrix_full();
states_kept      = get_local_state_id(s.link_list);
s.mm = s.mm(states_kept,states_kept);  % Match matrix
s.pm = s.pm(states_kept,states_kept);  % Direction matrix

% Calculate the edges of GS2, GS2r and GS3, since these are actually always
% the same.
% The reason that they are always the same is that you never know what the
% state of your neighbor is, so basically it is always likely that a
% neighbor can take any action or transition in any direction.
s.tgs2  = cell(1,size(Q0,1)); % Transitions when a neighbor computes an action
s.tgs2r = cell(1,size(Q0,1)); % Transitions when a neighbor computes an action without escape
s.tgs3  = cell(1,size(Q0,1)); % Transitions when a neighbor pops up from nowhere
for i = 1:size(Q0,1)
    [s.tgs2{i},s.tgs2r{i}] = gs2_patternformation(i,s.link_list);
    s.tgs3{i} = gs3_patternformation(i,s.link_list);
end

% Check baseline state-action map for proof. Else there is not much point.
fprintf('Testing Q0\n');
[fitness0,pass] = ga.fitness_function(Q0, s);
fprintf('Original fitness %f, pass %d \n',fitness0,pass);

end