%% Script to run the evolutions using PageRank for the consensus task
%
% Used in the paper:
% "The PageRank Algorithm as a Method to Optimize Swarm Behavior through Local Analysis"
% Mario Coppola, Jian Guo, Eberhard Gill, Guido de Croon, 2019.
%
% Mario Coppola, 2019

%% Initialize
init;

%% Set up input variables
fprintf('---- Starting Optimization ----');
data_write_folder = 'data_paper/consensus/evolutions/'; % Where the final data will be stored
runtime_ID = set_runtime_ID();
savedata = 0;
generations_max = 4000;
population.size = 10; % Genome population size
s.bw = 3; % Number of choices m

%% States
[ga, s, Q0] = initialize_parameters_consensus(generations_max, s);
gs1 = gs1_consensus(Q0,s.states);
[~,s.tgs2] = gs2_consensus(s.states);
[D,E] = pr_DE_consensus(s);

%% Initialize evolution
Qidx = find(double(Q0) > 0.01);
ga.genomelength = numel(Qidx); % The genome is all actions to be changed
population.genomelength = sum(Q0(:));
population_history_p{1} = ga_phase2_generate_initialpopulation(population, ga, s, Q0, Qidx);

%% Evolve
param = { 'normalize', 'all'}; % or '>1' for idle options, though here idle is also choosing yourself, so 'all' encompasses that
evolve_phase2;

%% Plot evolution and extract best
ga_phase2_analyze_history(population_history_p, 2, 'max', ['consensus',num2str(s.bw)], runtime_ID);
Q1 = ga_phase2_get_best(population_history_p, Q0, 'max', Qidx);
fprintf('Loaded\n')

%% Save the output of the evolution
if savedata
    make_folder(data_write_folder);
    save([data_write_folder,'consensus_m',num2str(s.bw), '_', num2str(runtime_ID), '_optim_',num2str(numel(population_history_p)),'gen.mat']);
end

%% Evaluate Baseline results for reference

% sml.des = s.des;
% sml.bw = s.bw;
% sml.observation = @model_pattern_local;
% sml.model = @model_pattern_global;
% sml.states = s.states;
% param_sim = { 'type', 'consensus', 'visualize', 1, 'verbose', 1};
% n_episodes = 100; % Number of runs
% 
% sml.n_agents = 5;
% stats{1} = simulation_episode_batch_launch (sml, Q0, n_episodes, param_sim{:});
% sml.n_agents = 10;
% stats{2} = simulation_episode_batch_launch (sml, Q0, n_episodes, param_sim{:});
% sml.n_agents = 20;
% stats{3} = simulation_episode_batch_launch (sml, Q0, n_episodes, param_sim{:});
% 
% fprintf('\n Done \n')
