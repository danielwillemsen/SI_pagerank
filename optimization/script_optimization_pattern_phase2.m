% Script to perform the probability optimization (phase 2)
% 
% Mario Coppola, 2018

%% Set up

% Normalize Q1t to not just be binary but to also be probabilistic
Q1t = bsxfun(@rdivide,double(Q1t),sum(Q1t,2));
Q1t(isnan(Q1t)) = 0;
Qidx = find(double(Q1t) > 0.01);

[ga, s] = initialize_parameters_pattern_phase2(pattern_name,generations_max);

ga.genomelength = numel(Qidx); % The genome is all actions to be changed
%%
% Importance vector, (re-)define as appropriate if wished.
% Default is all equal weight, so all states in Sdes are weighted equally
% in the fitness function
% s.des_importance = [1 1 1];
% ga.thresh = 0;  % Probability threshold beyond which we run proof

% Calculate the edges of GS2, GS2r and GS3, since these are actually always
% the same.
% The reason that they are always the same is that you never know what the
% state of your neighbor is, so basically it is always likely that a
% neighbor can take any action or transition in any direction.
s.tgs2  = cell(1,size(Q1t,1)); % Transitions when a neighbor computes an action
s.tgs2r = cell(1,size(Q1t,1)); % Transitions when a neighbor computes an action without escape
s.tgs3  = cell(1,size(Q1t,1)); % Transitions when a neighbor pops up from nowhere
for i = 1:size(Q1t,1)
    [s.tgs2{i},s.tgs2r{i}] = gs2_patternformation(i,s.link_list);
    s.tgs3{i} = gs3_patternformation(i,s.link_list);
end

% Create the initial population
population_history_p{1} = ga_phase2_generate_initialpopulation(population, ga, s, Q1t, Qidx,'init_mode','mutate');
%% Evolve
generation = numel(population_history_p);
population = population_history_p{numel(population_history_p)};
fname      = fieldnames(population_history_p{numel(population_history_p)});

stop_flag = 0;
while ~stop_flag
    generation = generation + 1;
    fprintf('\nStarting generation %d',generation);
    
    population = ga_phase2_sort_population    (population, fname, 'max');
    population = ga_phase2_select_elite       (population, ga);
    population = ga_phase2_generate_offspring (population, ga, s, Q1t, Qidx, 'normalize','>1');
    population = ga_phase2_generate_mutants   (population, ga, s, Q1t, Qidx, 'normalize','>1');
    [population_history_p, population] = ga_phase2_save_population(population_history_p,population,generation);
    stop_flag  = ga_stop( generation, ga.generations_max );
end

%% Plot evolution and extract best
ga_phase2_analyze_history(population_history_p, 2, 'max', pattern_name, runtime_ID);
Q2t = ga_phase2_get_best(population_history_p, Q1t, 'max', Qidx);
Q2  = zeros(255,8);
Q2(get_local_state_id(s.link_list),:) = Q2t;
fprintf('Loaded\n')

%% Save
make_folder(datafolder)
save([datafolder,num2str(pattern_name),'_',num2str(runtime_ID),'_phase2.mat']);

fprintf('Finished Phase 2')
