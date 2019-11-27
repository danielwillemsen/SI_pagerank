%% Script to run the evolutions using PageRank for the consensus task
% with the variant that the robots only know whether all neighbors join or not
% (hence the name: binary).
%
% Used in the paper:
% "The PageRank Algorithm as a Method to Optimize Swarm Behavior through Local Analysis"
% Mario Coppola, Jian Guo, Eberhard Gill, Guido de Croon, 2018.
%
% Mario Coppola, 2019

%% Initialize
init;

%% Set up input variables
fprintf('---- Starting Optimization ----');
data_write_folder = 'data/consensus/evolutions/'; % Where the final data will be stored
runtime_ID = set_runtime_ID();
savedata = 0;
generations_max = 1000;
population.size = 10; % Genome population size
s.bw = 2; % Number of m options

%% States
[ga, s, Q0] = initialize_parameters_consensus_binary(generations_max, s);
gs1 = gs1_consensus_binary(Q0,s.states);
s.gs2 = gs2_consensus_binary(s.states);
[D,E] = pr_DE_consensus_binary(s);

%% Initialize evolution
Qidx = find(double(Q0) > 0.01);
ga.genomelength = numel(Qidx); % The genome is all actions to be changed
population.genomelength = sum(Q0(:));
population_history_p{1} = ga_phase2_generate_initialpopulation(population, ga, s, Q0, Qidx);

%% Evolve
param = { 'normalize', '>1'};
evolve_phase2;

%% Plot evolution and extract best
ga_phase2_analyze_history(population_history_p, 2, 'max', ['consensus',num2str(s.bw)], runtime_ID);
Q1 = ga_phase2_get_best(population_history_p, Q0, 'max', Qidx);
fprintf('Loaded\n')

%% Save the output of the evolution
if savedata
    make_folder(data_write_folder);
    save([data_write_folder,'consensus_binary_m',num2str(s.bw),'_p0.3_', num2str(runtime_ID), '_optim_',num2str(numel(population_history_p)),'gen.mat']);
end