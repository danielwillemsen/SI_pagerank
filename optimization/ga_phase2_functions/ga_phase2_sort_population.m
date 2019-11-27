function population = ga_phase2_sort_population(population, fname, mode)
% ga_phase2_sort_population sorts the population by its score, either in ascending or in descending mode.
% This can be used in order to maximize or minimize a fitness function
%
% Mario Coppola, 2018

if strcmp(mode, 'max')
    [~, rank] = sort(population.score, 'descend');
elseif strcmp(mode, 'min')
    [~, rank] = sort(population.score, 'ascend');
else
    error('No valid mode provided')
end

for i = 1:numel(fname)
    if strcmp(fname{i}, 'score')
        population.(fname{i}) = population.(fname{i})(rank);
    elseif strcmp(fname{i}, 'population')
        population.(fname{i}) = population.(fname{i})(rank, :);
    end
end

end
