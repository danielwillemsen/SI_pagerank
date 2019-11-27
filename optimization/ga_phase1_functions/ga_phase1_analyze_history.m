function [bestscore_history, meanscore_history] = ga_phase1_analyze_history(populationhistory, figurenumber, mode, pattern_name, runtimeID)

% Get stats
generations = numel(populationhistory);
bestscore_history = zeros(1, generations);
meanscore_history = zeros(1, generations);
for i = 1:generations
    p = populationhistory{i};
    if strcmp(mode, 'max')
        bestscore_history(i) = max(p.score);
    elseif strcmp(mode, 'min')
        bestscore_history(i) = min(p.score);
    end
    meanscore_history(i) = mean(p.score);
end

% Figure
if generations >= 2
    newfigure(figurenumber, '', [pattern_name, '_', num2str(runtimeID), '_phase1']);
    plot(1:generations, bestscore_history, 'b--'); hold on;
    plot(1:generations, meanscore_history, 'r'); hold off;
    xlim([1 generations])
    xlabel('Generation')
    ylabel('Fitness')
    legend('Best', 'Mean', 'Location', 'SouthEast', 'Orientation', 'Horizontal')
end

end

