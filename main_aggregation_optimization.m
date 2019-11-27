%% Script to run the evolutions using PageRank for the aggregation task
%
% Used in the paper:
% "The PageRank Algorithm as a Method to Optimize Swarm Behavior through Local Analysis"
% Mario Coppola, Jian Guo, Eberhard Gill, Guido de Croon, 2019.
%
% Mario Coppola, 2019

%% Initialize
init;

for kk = 1:5 % Run 5 evolutionary trials
    clearvars -except kk

    %% Set up input variables
    fprintf('---- Starting Optimization ----');
    datafolder = 'data/aggregation/evolutions/'; % Where the final data will be stored
    runtime_ID = kk; %set_runtime_ID();
    generations_max = 1000;
    population.size = 10; % Genome population size

    %% States
    s.maxneighbors = 6;
    s.des = [];

    [ga, s, Q0] = initialize_parameters_aggregation(generations_max,s);

    gs1 = gs1_aggregation(Q0,s);
    [s.gs2] = gs2_aggregation(Q0,s);
    [D,E] = pr_DE_aggregation(s);

    %% Initialize evolution
    Qidx = find(double(Q0) > 0.01);
    ga.genomelength = numel(Qidx); % The genome is all actions to be changed
    population.genomelength = sum(Q0(:));
    population_history_p{1} = ga_phase2_generate_initialpopulation(population, ga, s, Q0, Qidx);

    %% Evolve
    param = {'normalize','all'};
    evolve_phase2;

    %% Plot evolution and extract best
    ga_phase2_analyze_history(population_history_p, 2, 'max', 'aggregation', runtime_ID);
    Q1 = ga_phase2_get_best(population_history_p, Q0, 'max', Qidx);
    fprintf('motion_p = {')
    for ev = 1:size(Q1,1)
        fprintf('%f',Q1(ev,2));
        if ev < size(Q1,1)
            fprintf(', ');
        end
    end
    fprintf('}; \n')

    %% Save the output of the evolution
    make_folder(datafolder);
    save([datafolder, 'aggregation_p0.5_', num2str(runtime_ID), '_optim_',num2str(numel(population_history_p)),'gen.mat']);
end