function population = ga_phase2_generate_initialpopulation(population, ga, s, Q, Qidx,varargin)
% ga_phase2_generate_initialpopulation generates the initial population for the
% optimization. This is done by randomly mutating a randomly selected part
% of the genome
%
% Mario Coppola, 2018

normalize = checkifparameterpresent(varargin, 'normalize', 'all', 'string');
init_mode = checkifparameterpresent(varargin, 'init_mode', 'random', 'string');

% Initialize
population.population = ones(population.size, ga.genomelength);
population.score = zeros(1, population.size);

% Go through all the genomes
genome = 1;
while genome <= population.size
    fprintf('\nGenerating population member %d', genome);
    
    if strcmp(init_mode,'random')
        new_mutated = rand(1,numel(Qidx));
    elseif strcmp(init_mode,'mutate')
        new_mutated = population.population(genome, :);
        m = ceil(ga.mutation_rate * randi([1, size(new_mutated, 2)]));
        rs = randsample(1:size(new_mutated, 2), m); % Randomly sample a part of the genome
        new_mutated(rs) = rand(1, m); % Generate random mutations for those randomly sampled genes in the genome
    end
    
    Qtest = double(Q); % Initialize copy of Q to test on
    Qtest(Qidx) = new_mutated; % Set mutated values
    
    if strcmp(normalize,'>1')
        Qt = Qtest((sum(Qtest, 2) > 1), :); % Get sum larger one
        Qtest((sum(Qtest, 2) > 1), :) = Qt ./ sum(Qt, 2);
    elseif strcmp(normalize,'all')
        Qt = Qtest;
        Qtest = Qt ./ sum(Qt,  2); % Normalize
    end
    Qtest(isnan(Qtest)) = 0; % Remove NaN just in case
    
    new_mutated = Qtest(Qidx); % Re-store normalized mutations
    
    fitness = ga.fitness_function(Qtest, s);
    
    population.population(genome, :) = new_mutated; % store population
    population.score(genome) = fitness; % store fitness
    genome = genome + 1;
    
end

end
