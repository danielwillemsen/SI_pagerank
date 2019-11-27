function population = ga_phase1_generate_initialpopulation(population, ga, s, Q0)
% ga_phase1_generate_initialpopulation generates the initial population for the
% optimization. This is done by randomly mutating a randomly selected part
% of the genome with a NOT operator, starting from a population of all 1s.
%
% Mario Coppola, 2018

fprintf('Generating initial population\n')

population.population = ones(population.size, population.genomelength);
i = 1;
while i <= population.size
    population.mutations{i} = randsample(1:population.genomelength, ceil(ga.mutation_rate * randi([1, population.genomelength])));
    population.population(i, :) = 1; % Initial population all ones.
    population.population(i, population.mutations{i}) = 0; % Random mutations to 0
    population.Q{i} = Q0;
    population.Q{i}(Q0 == 1) = population.population(i, :);
    [population.score(i), pass] = ga.fitness_function(population.Q{i}, s); % Check if it passes the proof, else try again
    if pass
        fprintf('Created population member %d/%d\n', i, population.size)
        i = i + 1;
    end
end

end

