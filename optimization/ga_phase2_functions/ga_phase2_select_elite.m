function population = ga_phase2_select_elite(population, ga)
% ga_phase2_select_elite uses Extracts elite members into new generation.
% This is tailored to the data structure of Phase 2.
%
% Mario Coppola, 2018

elite_bounds = 1:ceil(ga.elite * population.size);
population.new_generation.elite = population.population (elite_bounds, :);
population.new_generation.elite_score = population.score(elite_bounds);

end
