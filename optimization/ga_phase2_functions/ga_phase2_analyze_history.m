function [bestscore_history, meanscore_history] = ga_phase2_analyze_history(populationhistory, figurenumber, mode, pattern_name, runtimeID)
% ga_phase2_analyze_history analyzes the evolution history of Phase 2 and produces a figure showing the evolution.
%
% Mario Coppola, 2018

generations = numel(populationhistory);
bestscore_history = zeros(1, generations);
meanscore_history = zeros(1, generations);

allscores = zeros(generations, numel(populationhistory{1}.score));
for i = 1:generations
    p = populationhistory{i};
    allscores(i, :) = populationhistory{i}.score;
    if strcmp(mode, 'max')
        bestscore_history(i) = max(p.score);
    elseif strcmp(mode, 'min')
        bestscore_history(i) = min(p.score);
    end
    meanscore_history(i) = mean(p.score);
end

if generations >= 2
    if figurenumber > 0
        newfigure(figurenumber, '', [pattern_name, '_', num2str(runtimeID), '_phase2']);
    end
    plot(1:generations, bestscore_history, 'b--'); hold on;
    plot(1:generations, meanscore_history, 'r'); hold on;
    xlim([1 generations])
    xlabel('Generation')
    ylabel('Fitness')
    legend('Best', 'Mean', 'Location', 'SouthEast', 'Orientation', 'Horizontal')
end

end
