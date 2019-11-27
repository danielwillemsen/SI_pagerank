function [populationhistory, population] = ga_phase2_save_population(populationhistory, population, generation)
% ga_phase2_save_population stores the population data of a given generation into a cell array and prepares the next population.
% This is tailored to the data structure of phase 2.
%
% Mario Coppola, 2018

populationhistory{generation} = population;

population.population = [population.new_generation.elite;
	population.new_generation.offsprings;
	population.new_generation.mutated];
population.score = [population.new_generation.elite_score, ...
	population.new_generation.offsprings_score, ...
	population.new_generation.mutated_score];
population = rmfield(population, 'new_generation');

end


