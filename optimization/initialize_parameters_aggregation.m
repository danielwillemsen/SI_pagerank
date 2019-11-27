function [ga, s, Q0] = initialize_parameters_aggregation(generations_max,s)
%initialize_parameters_aggregation initializes the parameters of the GA for the aggregation task
%
% Mario Coppola, 2019

% GA Parameters
ga.fitness_function = @fitness_aggregation_centrality; % Fitness function handle
ga.mutation_rate = 0.1; % Mutation rate
% Population breakdown (the three values below must sum up to 1)
ga.elite = 0.3; % Percentage of population that is elite
ga.parents = 0.4; % Percentage of population that reproduces
ga.mutate = 0.3; % Percentage of population that mutates
ga.generations_max = generations_max; % Maximum Generations
ga.max_trials = inf; % Maximum reproduction/mutation trials before giving up

s.states = 1:s.maxneighbors+1;
Q0 = 0.5*ones(numel(s.states),2);
Q0(s.des,1) = 1; % Stop probability at s.des
Q0(s.des,2) = 0; % Move probability at s.des

end
