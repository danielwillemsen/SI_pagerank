function [bestscore_history, meanscore_history] = ga_analyze_history(evo, mode, color)
% ga_analyze_history analyzes the history of a ga and plots the fitness evolution
%
% Mario Coppola, 2018

% Get stats
for ev = 1:numel(evo)
    if isfield(evo{ev}, 'population_history_q')
        populationhistory = evo{ev}.population_history_q;
    elseif isfield(evo{ev}, 'population_history_p')
        populationhistory = evo{ev}.population_history_p;
    else
        keyboard
    end
 
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
 
    linestyle = {'-', '--', ':', '-.', '-', '--', ':', '-.'};
    % Figure
    if generations >= 2
        plot(1:generations, bestscore_history, 'color', color{ev + 1}, 'linestyle', linestyle{ev}, 'linewidth', 2); hold on;
        xlim([1 generations])
        xlabel('Generation')
        ylabel('Fitness')
    end
    hold on
end
legend('E1','E2','E3','E4','E5','Location','NorthOutside','Orientation','Horizontal')

end

