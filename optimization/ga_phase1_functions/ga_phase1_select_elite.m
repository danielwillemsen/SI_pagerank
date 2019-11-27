function population = ga_phase1_select_elite(population, param)
% ga_phase1_select_elite uses Extracts elite members into new generation.
% This is tailored to the data structure of Phase 1.
%
% Mario Coppola, 2018

elite_bounds = 1:ceil(param.elite * population.size);
population.new_generation.elite = population.population (elite_bounds, :);
population.new_generation.elite_score = population.score(elite_bounds);
population.new_generation.elite_Q = population.Q(elite_bounds);
population.new_generation.elite_mutations = population.mutations(elite_bounds);

end