function [ga, s, Q0] = initialize_parameters_consensus(generations_max, s)
%initialize_parameters_consensus_binary initializes the parameters for evolving the consensus task (binary variant)
%
% Mario Coppola, 2019

% GA Parameters
ga.fitness_function = @fitness_consensus_centrality; % Fitness function handle
ga.mutation_rate = 0.1; % Mutation rate
% Population breakdown (the three values below must sum up to 1)
ga.elite = 0.3; % Percentage of population that is elite
ga.parents = 0.4; % Percentage of population that reproduces
ga.mutate = 0.3; % Percentage of population that mutates
ga.generations_max = generations_max; % Maximum Generations
ga.max_trials = inf; % Maximum reproduction/mutation trials before giving up

% States
s.maxneighbors = 8;
k = uint8(permn(0:s.maxneighbors,s.bw)); k(sum(k,2)>s.maxneighbors,:) = [];
a = rude(repmat(size(k,1),1,s.bw),1:s.bw)';
s.states = [a, repmat(k,s.bw,1)];
n_neighbors = sum(s.states(:,2:end),2);
s.states(n_neighbors==0,:) = [];
s.n_neighbors = sum(s.states(:,2:end),2);

% Desired states
s.des = [];
for i = 1:s.bw
    des = [i*ones(s.maxneighbors,1), zeros(s.maxneighbors,i-1), (1:s.maxneighbors)',zeros(s.maxneighbors,s.bw-i)];
    [~,index] = ismember(des,s.states,'rows');
    s.des = [s.des index'];
end

Q0 = init_policy_consensus(s.states); % Generate the initial Q matrix
Q0(s.des,:) = 0;

end
