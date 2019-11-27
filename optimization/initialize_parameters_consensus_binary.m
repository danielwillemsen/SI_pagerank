function [ga, s, Q0] = initialize_parameters_consensus_binary(generations_max, s)
%initialize_parameters_consensus_binary initializes the parameters for evolving the consensus task (binary variant)
%
% Mario Coppola, 2019

% GA Parameters
ga.fitness_function = @fitness_consensus_binary_centrality; % Fitness function handle
ga.mutation_rate = 0.1; % Mutation rate
% Population breakdown (the three values below must sum up to 1)
ga.elite = 0.3; % Percentage of population that is elite
ga.parents = 0.4; % Percentage of population that reproduces
ga.mutate = 0.3; % Percentage of population that mutates
ga.generations_max = generations_max; % Maximum Generations
ga.max_trials = inf; % Maximum reproduction/mutation trials before giving up

% States
k = repmat([0 1]',s.bw,1);
a = rude(repmat(2,s.bw,1),1:s.bw)';
s.states = [a, k];
s.des = find(s.states(:,2)==1); % Desired states

Q0 = init_policy_consensus_binary(s); % Generate the initial Q matrix
Q0(s.des,:) = 0;

end
