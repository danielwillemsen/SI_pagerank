%% Script to test the evolution result for the consensus task (binary variant) evolved with PageRank
%
% Used in the paper:
% "The PageRank Algorithm as a Method to Optimize Swarm Behavior through Local Analysis"
% Mario Coppola, Jian Guo, Eberhard Gill, Guido de Croon, 2019.
%
% Mario Coppola, 2019

%% Initialize
init;

%% Set up input variables
fprintf('---- Starting Evaluation ----');
data_read_folder = 'data_paper/consensus/evolutions/';
data_write_folder = 'data/consensus/evaluations/';
savedata = 0;
m = 2; % number of choices
n_agents = [5 10 20]; % number of robots in the swarm
n_exp = 5; % number of evolutions

%% Load evolutions
fprintf('Loading evolutions');
filenames = dir([data_read_folder, 'consensus_binary_m',num2str(m),'_p0.3_*.mat']);

%% Run tests
fprintf('Running tests');
stats = cell(numel(filenames),3);
for i = 1:numel(filenames)
    data = load(filenames(i).name);
    sml.des = data.s.des;
    sml.bw = data.s.bw;
    sml.states = data.s.states;
    Q1 = ga_phase2_get_best(data.population_history_p, data.Q0, 'max', data.Qidx);
    param_sim = { 'type', 'consensus_binary', 'visualize', 0, 'verbose', 1};
    n_episodes = 100; % Number of runs
    
    for j = 1:numel(n_agents)
        sml.n_agents = n_agents(j);
        stats{i,j} = simulation_episode_batch_launch (sml, Q1, n_episodes, param_sim{:});
    end
end
fprintf('\n Done \n')

%% Save data
if savedata
    clear data Q1
    make_folder(data_write_folder);
    save([data_write_folder,'consensus_binary',num2str(m),'_p0.3_results_5_10_20.mat']);
end
