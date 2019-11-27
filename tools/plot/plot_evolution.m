function plot_evolution(fignumber, data, title)
% plot_evolution plots the results of an evolution from GA runs
%
% Mario Coppola, 2018

color = {[0 0 0], [1 0 0], [0 0.5 0], [0 0 1], [1 0.5 0], [0.75, 0, 0.75]};
if (nargin < 3)
    title = '';
end

newfigure(fignumber,'',title);

for g = 1:numel(data)
    populationhistory = data{g}.population_history_p;
    generations = numel(populationhistory);
    bestscore_history = zeros(1, generations);
    
    allscores = zeros(generations, numel(populationhistory{1}.score));
    for i = 1:generations
        p = populationhistory{i};
        allscores(i, :) = populationhistory{i}.score;
        bestscore_history(i) = max(p.score);
    end
    
    plot(1:generations, bestscore_history, 'color', color{g + 1});
    hold on;
end
legend('E1','E2','E3','E4','E5','Location','NorthOutside','Orientation','Horizontal')
xlim([1 generations]);
xlabel('Generation');
ylabel('Fitness');

end

