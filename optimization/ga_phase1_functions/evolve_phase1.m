%% Script to run (or continue running) phase 1 evolutions
generation = numel(population_history_q);
population = population_history_q{numel(population_history_q)};
fname      = fieldnames(population_history_q{numel(population_history_q)});

stop_flag = 0;
while ~ stop_flag
    generation = generation + 1;
    fprintf('\nStarting generation %d\n', generation);
 
    population = ga_phase1_sort_population (population, fname, 'max');
    population = ga_phase1_select_elite (population, ga);
    population = ga_phase1_generate_offspring (population, ga, s, Q0t);
    population = ga_phase1_generate_mutants (population, ga, s, Q0t);
    [population_history_q, population] = ga_phase1_save_population(population_history_q, population, generation);
    stop_flag = ga_stop(generation, ga.generations_max);
end