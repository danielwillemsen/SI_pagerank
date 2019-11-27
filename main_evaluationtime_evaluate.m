%% Script to analyze the results of the evolutions using PageRank for the aggregation task
%
% Used in the paper:
% "The PageRank Algorithm as a Method to Optimize Swarm Behavior through Local Analysis"
% Mario Coppola, Jian Guo, Eberhard Gill, Guido de Croon, 2018.
%
% Mario Coppola, 2019

%% Initialize
init;

%% Set up general parameters
population.size = 100; % Genome population size
data_write_folder = 'data/evaluation_times/';
%% Consensus

clearvars -except population data_write_folder
fprintf('---- Evaluating Consensus ----');
m = 2:4;
s = cell(1,numel(m));
Q0 = cell(1,numel(m));
consensus_time_vect = zeros(population.size,numel(m));
for i = 1:numel(m)
    fprintf('\n\nEvaluating for m=%d', m(i));
    s{i}.bw = m(i);
    [ga, s{i}, Q0{i}] = initialize_parameters_consensus(1, s{i});
    s{i}.gs1 = gs1_consensus(Q0{i},s{i}.states);
    [s{i}.gs2,s{i}.tgs2] = gs2_consensus(s{i}.states);
    [D,E] = pr_DE_consensus(s{i});
    Qidx = find(double(Q0{i}) > 0.01);
    ga.genomelength = numel(Qidx); % The genome is all actions to be changed
    population.genomelength = sum(Q0{i}(:));
    
    consensus_time_vect(:,i) = ga_phase2_evaluate_fitness_tictoc(population, ga, s{i}, Q0{i}, Qidx);
end

clearvars -except consensus_time_vect Q0 s population data_write_folder
make_folder(data_write_folder);
save([data_write_folder,'consensus_time_vect']);

%% Consensus binary

clearvars -except population data_write_folder
fprintf('---- Evaluating Consensus (binary variant)----');
m = 2:50;
s = cell(1,numel(m));
Q0 = cell(1,numel(m));
consensus_binary_time_vect = zeros(population.size,numel(m));
for i = 1:numel(m)
    fprintf('\n\nEvaluating for m=%d', m(i));
    s{i}.bw = m(i);
    [ga, s{i}, Q0{i}] = initialize_parameters_consensus_binary(1, s{i});
    s{i}.gs1 = gs1_consensus_binary(Q0{i},s{i}.states);
    s{i}.gs2 = gs2_consensus_binary(s{i}.states);
    [D,E] = pr_DE_consensus_binary(s{i});
    Qidx = find(double(Q0{i}) > 0.01);
    ga.genomelength = numel(Qidx); % The genome is all actions to be changed
    population.genomelength = sum(Q0{i}(:));
    
    consensus_binary_time_vect(:,i) = ga_phase2_evaluate_fitness_tictoc(population, ga, s{i}, Q0{i}, Qidx);
end

clearvars -except consensus_binary_time_vect Q0 s population data_write_folder
make_folder(data_write_folder);
save([data_write_folder,'consensus_binary_time_vect']);

%% Aggregation

clearvars -except population data_write_folder
fprintf('---- Evaluating Aggregation ----');
m = 2:100;
aggregation_time_vect = zeros(population.size,numel(m));
s = cell(1,numel(m));
Q0 = cell(1,numel(m));
for i = 1:numel(m)
    fprintf('\n\nEvaluating for m=%d', m(i));
    s{i}.maxneighbors = m(i);
    s{i}.des = [];
    [ga, s{i}, Q0{i}] = initialize_parameters_aggregation(1,s{i});
    s{i}.gs1 = gs1_aggregation(Q0{i},s{i});
    [s{i}.gs2] = gs2_aggregation(Q0{i},s{i});
    [D,E] = pr_DE_aggregation(s{i});
    Qidx = find(double(Q0{i}) > 0.01);
    ga.genomelength = numel(Qidx); % The genome is all actions to be changed
    population.genomelength = sum(Q0{i}(:));
    aggregation_time_vect(:,i) = ga_phase2_evaluate_fitness_tictoc(population, ga, s{i}, Q0{i}, Qidx);
end

clearvars -except aggregation_time_vect Q0 s population data_write_folder
make_folder(data_write_folder);
save([data_write_folder,'aggregation_time_vect']);

%% Pattern Formation (phase 2)

clearvars -except population data_write_folder
fprintf('---- Evaluating Pattern Formation phase 2----');
pattern_list = {'triangle4','hexagon','triangle9','T'};
n_agents = [4 6 9 12];
s = cell(1,numel(pattern_list));
Q1t = cell(1,numel(pattern_list));
patternformation_time_vect = zeros(population.size,numel(pattern_list));
for exp = 1:numel(pattern_list)
    pattern_name = pattern_list{exp};
    fprintf(['\n\nEvaluating for ', pattern_name,'\n']);
    [~, s{exp}, Q0t, fitness0] = initialize_parameters_pattern_phase1(pattern_name, 1, n_agents(exp));
    population.genomelength = sum(Q0t(:));
    Q0 = zeros(255, 8);
    Q0(get_local_state_id(s{exp}.link_list), :) = Q0t;
    Q1t{exp} = Q0t;
    Q1t{exp} = bsxfun(@rdivide,double(Q1t{exp}),sum(Q1t{exp},2));
    Q1t{exp}(isnan(Q1t{exp})) = 0;
    Qidx = find(double(Q1t{exp}) > 0.01);
    [ga, s{exp}] = initialize_parameters_pattern_phase2(pattern_name,1, n_agents(exp));

    ga.genomelength = numel(Qidx); % The genome is all actions to be changed
    s{exp}.tgs2  = cell(1,size(Q1t{exp},1)); % Transitions when a neighbor computes an action
    s{exp}.tgs2r = cell(1,size(Q1t{exp},1)); % Transitions when a neighbor computes an action without escape
    s{exp}.tgs3  = cell(1,size(Q1t{exp},1)); % Transitions when a neighbor pops up from nowhere
    for i = 1:size(Q1t{exp},1)
        [s{exp}.tgs2{i},s{exp}.tgs2r{i}] = gs2_patternformation(i,s{exp}.link_list);
        s{exp}.tgs3{i} = gs3_patternformation(i,s{exp}.link_list);
    end
    
    % Create the initial population
    params = {'normalize', '<1'};
    patternformation_time_vect(:,exp) = ga_phase2_evaluate_fitness_tictoc(population, ga, s{exp}, Q1t{exp}, Qidx, params{:});

end

clearvars -except patternformation_time_vect Q0 s population data_write_folder
make_folder(data_write_folder);
save([data_write_folder,'patternformation_time_vect']);

%% Pattern Formation (phase 2) -- line

clearvars -except population data_write_folder
fprintf('---- Evaluating Pattern Formation lineNE----');
pattern_name = 'lineNE';
n_agents = 3:20;
s = cell(1,numel(n_agents));
Q1t = cell(1,numel(n_agents));
patternformation_lineNE_time_vect = zeros(population.size,numel(n_agents));
for i = 1:numel(n_agents)
    fprintf('\nEvaluating for %d robots \n', n_agents(i));
    [~, s{i}, Q0t, fitness0] = initialize_parameters_pattern_phase1(pattern_name, 1, n_agents(i));
    population.genomelength = sum(Q0t(:));
    Q0 = zeros(255, 8);
    Q0(get_local_state_id(s{i}.link_list), :) = Q0t;
    Q1t{i} = Q0t;
    Q1t{i} = bsxfun(@rdivide,double(Q1t{i}),sum(Q1t{i},2));
    Q1t{i}(isnan(Q1t{i})) = 0;
    Qidx = find(double(Q1t{i}) > 0.01);
    [ga, s{i}] = initialize_parameters_pattern_phase2(pattern_name,1, n_agents(i));

    ga.genomelength = numel(Qidx); % The genome is all actions to be changed
    s{i}.tgs2  = cell(1,size(Q1t{i},1)); % Transitions when a neighbor computes an action
    s{i}.tgs2r = cell(1,size(Q1t{i},1)); % Transitions when a neighbor computes an action without escape
    s{i}.tgs3  = cell(1,size(Q1t{i},1)); % Transitions when a neighbor pops up from nowhere
    for j = 1:size(Q1t{i},1)
        [s{i}.tgs2{j},s{i}.tgs2r{j}] = gs2_patternformation(j,s{i}.link_list);
        s{i}.tgs3{j} = gs3_patternformation(j,s{i}.link_list);
    end
    % Create the initial population
    params = {'normalize', '<1'};
    patternformation_lineNE_time_vect(:,i) = ga_phase2_evaluate_fitness_tictoc(population, ga, s{i}, Q1t{i}, Qidx, params{:});

end

clearvars -except patternformation_lineNE_time_vect Q0 s population data_write_folder
make_folder(data_write_folder);
save([data_write_folder,'patternformation_lineNE_time_vect']);

