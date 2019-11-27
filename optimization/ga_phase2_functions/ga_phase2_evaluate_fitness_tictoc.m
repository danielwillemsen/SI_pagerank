function time_v = ga_phase2_evaluate_fitness_tictoc(population, ga, s, Q, Qidx,varargin)
% ga_phase2_evaluate_fitness_tictoc measures the time taken to calculate the pagerank over random iterations of a policy
%
% Mario Coppola, 2018

normalize = checkifparameterpresent(varargin, 'normalize', 'all', 'string');
init_mode = checkifparameterpresent(varargin, 'init_mode', 'random', 'string');

% Initialize
population.population = ones(population.size, ga.genomelength);
population.score = zeros(1, population.size);

% Go through all the genomes
genome = 1;
time_v = zeros(1,population.size);
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
    
    pr = tic;
    ga.fitness_function(Qtest, s);
    time_v(genome) = toc(pr);
    
    genome = genome + 1;
    
end

end
