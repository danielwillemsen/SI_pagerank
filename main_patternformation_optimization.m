%% Script to run the optimization for the pattern formation task
%
% Used in the paper:
% "The PageRank Algorithm as a Method to Optimize Swarm Behavior through Local Analysis"
% Mario Coppola, Jian Guo, Eberhard Gill, Guido de Croon, 2018.
%
% Mario Coppola, 2018


%% Initialize
init;

%% Set up input variables
fprintf('---- Starting Optimization ----');
datafolder   = 'data/'; % Where the final data will be stored
prompt       = '\n\nWhich pattern would you like to use? \n >> ';
pattern_name = input(prompt, 's');
runtime_ID   = set_runtime_ID();
run_phase_1  = 1;

%% Evolve Phase 1
% The resulting state-action map will be stored as Q1
fprintf('\n---- GA Phase 1 ----\n');
generations_max = 2000; %#ok<NASGU> Generations of GA
population.size = 10; % Genome population size
script_optimization_pattern_phase1 % Script Phase 1

%% Evolve Phase 2
fprintf('\n---- GA Phase 2 ----\n');
% Clear variables that we don't need
clearvars -except runtime_ID pattern_name datafolder Q0 Q1 Q0t Q1t fitness0 sml
generations_max = 1000; % Generations of GA
population.size = 20; % Genome population size
script_optimization_pattern_phase2 % Script Phase 2

%% Evaluation
script_quick_evaluation_pattern % Script evaluation
