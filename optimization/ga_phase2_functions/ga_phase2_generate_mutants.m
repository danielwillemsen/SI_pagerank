function population = ga_phase2_generate_mutants(population, ga, s, Q, Qidx, varargin)
% ga_phase2_generate_mutated mutates genomes in the population for the
% optimization. This is done by randomly mutating a randomly selected part
% of the genome.
%
% Mario Coppola, 2018

normalize = checkifparameterpresent(varargin, 'normalize', 'all', 'string');

mutated_bounds = randi(ga.mutate * population.size, ga.mutate * population.size, 1);
mutated = population.population(mutated_bounds, :);
population.new_generation.mutated = mutated;
population.new_generation.mutated_score = population.score(mutated_bounds);

member = 1;
while member <= size(mutated, 1)
    new_mutated = mutated(member, :);
    m = ceil(ga.mutation_rate * randi([1, size(new_mutated, 2)]));
    rs = randsample(1:size(new_mutated, 2), m);
    new_mutated(rs) = rand(1, m);
    
    Qtest = double(Q);
    Qtest(Qidx) = new_mutated;
    
    if strcmp(normalize,'>1')
        Qt = Qtest((sum(Qtest, 2) > 1), :); % Get sum larger one
        Qtest((sum(Qtest, 2) > 1), :) = Qt ./ sum(Qt, 2);
    elseif strcmp(normalize,'all')
        Qt = Qtest;
        Qtest = Qt ./ sum(Qt,  2); % Normalize
    end
    Qtest(isnan(Qtest)) = 0; % Remove NaN just in case
    
    new_mutated = Qtest(Qidx);
    
    fitness = ga.fitness_function(Qtest, s);
    
    population.new_generation.mutated(member, :) = new_mutated;
    population.new_generation.mutated_score(member) = fitness;
    member = member + 1;
    
end

end
