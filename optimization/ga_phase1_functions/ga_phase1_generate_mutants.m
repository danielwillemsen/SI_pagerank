function population = ga_phase1_generate_mutants(population, ga, s, Q0)
% ga_phase1_generate_mutated mutates genomes in the population for the
% optimization. This is done by randomly mutating a randomly selected part
% of the genome.
%
% Mario Coppola, 2018

mutated_bounds = randi(population.size,ga.mutants*population.size,1);
mutated = population.population(mutated_bounds,:);
mutated_score = population.score(mutated_bounds);
population.new_generation.mutated = mutated;
population.new_generation.mutated_score = mutated_score;
population.new_generation.mutated_Q = population.Q(mutated_bounds);
population.new_generation.mutated_mutations = population.mutations(mutated_bounds);

genome = 1;
mutation_trial = 1;

while genome <= size(mutated,1)
    
    test_mutated = mutated(genome,:);
    m = ceil(ga.mutation_rate*randi([1,population.genomelength]));
    rs = randsample(1:population.genomelength,m); % Randomly select genes in a genome

    test_mutated(rs) = double(~test_mutated(rs)); % Application of NOT operator
    
    Qtest = Q0;
    Qtest(Q0==1) = test_mutated;

    [score,pass] = ga.fitness_function(Qtest, s);
        
    if pass
        population.new_generation.mutated(genome,:) = test_mutated;
        population.new_generation.mutated_score(genome) = score;
        population.new_generation.mutated_Q{genome} = Qtest;
        population.new_generation.mutated_mutations{genome} = find(test_mutated==0);
        genome = genome+1;
        mutation_trial = 1;
    elseif mutation_trial > ga.max_trials
        population.new_generation.offsprings_score(genome) = population.score(genome);
        genome = genome+1;
        mutation_trial = 1;
    end
    mutation_trial = mutation_trial + 1;
    
end

end

