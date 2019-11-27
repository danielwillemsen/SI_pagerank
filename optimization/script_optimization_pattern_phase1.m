% Script to perform the first optimization (phase 1) where actions
% are removed, based on the pagerank fitness, if they are not necessary
% to pass the proof.
%
% Mario Coppola, 2018

%% Set up the evolution parameters

% Set up the initial parameters of the genetic algorithm
% Overall there are two main structures carried forward:
% ga: contains details of the GA
% s : contains state information
[ga, s, Q0t, fitness0] = initialize_parameters_pattern_phase1(pattern_name, generations_max);
population.genomelength = sum(Q0t(:));

% Create the initial population
if run_phase_1
    population_history_q{1} = ga_phase1_generate_initialpopulation(population, ga, s, Q0t);
end

s.states = 1:size(Q0t, 1);
s.simplicial = find_simplicial(s.link_list(1:end - 1, :));
s.static_0 = s.states(~ any(Q0t, 2));

% Reduced version mapped onto main version. Needed later for simulation.
Q0 = zeros(255, 8);
Q0(get_local_state_id(s.link_list), :) = Q0t;

%% Evolve
if run_phase_1
    evolve_phase1;
end

%% Plot evolution and store best result
if run_phase_1
    % Plot results of evolution
    ga_phase1_analyze_history(population_history_q, 1, 'max', pattern_name, runtime_ID);
 
    % Store the best result in the new state-action map Q1
    Q1t = ga_phase1_get_best(population_history_q, 'max');
    Q1 = zeros(255, 8);
    Q1(get_local_state_id(s.link_list), :) = Q1t;
else
    % In case we directly go to probability optimization, then Q1 = Q0
    Q1t = Q0t;
end

%% Save the output of the evolution and figures
if run_phase_1
    % Save the output of the evolution
    make_folder(datafolder);
    save([datafolder, pattern_name, '_', num2str(runtime_ID), '_phase1.mat']);
end

fprintf('Finished Phase 1')
