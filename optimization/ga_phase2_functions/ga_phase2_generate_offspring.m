function population = ga_phase2_generate_offspring(population, ga, s, Q, Qidx, varargin)
% ga_phase2_generate_offspring generates the offspring
% Offspring are the weighted mean of the two parents
%
% Mario Coppola, 2018

normalize = checkifparameterpresent(varargin, 'normalize', 'all', 'string');

parents_bounds = 1:ceil(ga.parents * population.size);
parents = population.population(parents_bounds, :);
population.new_generation.offsprings = parents;
population.new_generation.offsprings_score = population.score(parents_bounds);

genome = 1;

while genome <= size(parents, 1)
    
    % Select a parent
    randpartner = randi(parents_bounds(end), 1);
    
    % Mate the parents
    offspring_test = [parents(genome, :); population.population(randpartner, :)];
    scores = [population.score(genome) population.score(randpartner)];
    
    % Offspring are the weighted mean of the two parents
    offspring = weighted_mean(offspring_test, scores',1);
    
    % Test the child
    Qtest = double(Q);
    Qtest(Qidx) = offspring;
    
    if strcmp(normalize,'>1')
        Qt = Qtest((sum(Qtest, 2) > 1), :); % Get sum larger one
        Qtest((sum(Qtest, 2) > 1), :) = Qt ./ sum(Qt, 2);
    elseif strcmp(normalize,'all')
        Qt = Qtest;
        Qtest = Qt ./ sum(Qt,  2); % Normalize
    end
    Qtest(isnan(Qtest)) = 0; % Remove NaN just in case
    
    offspring = Qtest(Qidx);
    fitness = ga.fitness_function(Qtest, s);
    
    population.new_generation.offsprings (genome, :) = offspring;
    population.new_generation.offsprings_score(genome) = fitness;
    genome = genome + 1;
    
end

end
