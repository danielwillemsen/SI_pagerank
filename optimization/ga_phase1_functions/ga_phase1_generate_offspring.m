function population = ga_phase1_generate_offspring(population, param, s, Q0)
% ga_phase1_generate_offspring generates the offspring
%
% Mario Coppola, 2018

% Initialize
parents_bounds = 1:ceil(param.parents * population.size);
parents = population.population(parents_bounds, :);
parents_score = population.score(parents_bounds);
population.new_generation.offsprings = parents;
population.new_generation.offsprings_score = parents_score;
population.new_generation.offsprings_Q = population.Q(parents_bounds);
population.new_generation.offsprings_mutations = population.mutations(parents_bounds);

genome = 1;
reproduction_trial = 1;

while genome <= size(parents, 1)
 
    randpartner = randi(population.size, 1); % select a random partner
    test_offspring = and(parents(genome, :), population.population(randpartner, :));
    Qtest = Q0;
    Qtest(Q0 == 1) = test_offspring;

    if any(parents(genome, :) - population.population(randpartner, :))
        % Evaluate fitness (and determine whether the two conditions are fulfilled)
        [score, pass] = param.fitness_function(Qtest, s);
    else 
        % Child is equal to the parents, meaning that the score is passed over. The child also automatically passes the proof.
        fprintf('\tChild is equal to parents\n');
        pass = 1;
        score = parents_score(genome);
    end
 
    if pass
        population.new_generation.offsprings(genome, :) = test_offspring;
        population.new_generation.offsprings_score(genome) = score;
        population.new_generation.offsprings_Q{genome} = Qtest;
        population.new_generation.offsprings_mutations{genome} = find(test_offspring == 0);
        genome = genome + 1;
        reproduction_trial = 1;
    elseif reproduction_trial > param.max_trials
        % Move on. This genome cannot reproduce. He is promoted to elite.
        genome = genome + 1;
        reproduction_trial = 1;
    end
    reproduction_trial = reproduction_trial + 1;
end

end
