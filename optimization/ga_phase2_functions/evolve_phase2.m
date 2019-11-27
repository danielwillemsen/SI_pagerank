%% Script to run (or continue running) phase 2 evolutions
% The parameter param{:} must be specified prior to this script
% or else the functions
%   > ga_phase2_generate_offspring
%   > ga_phase2_generate_mutants
% will return an error
%
% Mario Coppola

generation = numel(population_history_p);
population = population_history_p{numel(population_history_p)};
fname      = fieldnames(population_history_p{numel(population_history_p)});

stop_flag = 0;
while ~ stop_flag
    generation = generation + 1;
    fprintf('\nStarting generation %d',generation);

    population = ga_phase2_sort_population (population, fname, 'max');
    population = ga_phase2_select_elite (population, ga);
    population = ga_phase2_generate_offspring (population, ga, s, Q0, Qidx, param{:});
    population = ga_phase2_generate_mutants (population, ga, s, Q0, Qidx, param{:});
    [population_history_p, population] = ga_phase2_save_population(population_history_p,population,generation);
    stop_flag = ga_stop( generation, ga.generations_max );
end
