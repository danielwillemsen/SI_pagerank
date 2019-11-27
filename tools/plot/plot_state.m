function plot_state(state)
% plot_state plots the local state on a grid. It can be used for debugging purposes
%
% Mario Coppola, 2018

pp = statespace_grid;
link = dec2bin(state, 8) - '0';
pp(find(link == 0), :) = []; % Identify neighbor positions

% Plot neighbors
for j = 1:size(pp, 1) 
    plot([0; pp(j, 1)], [0; pp(j, 2)], 'k-o', 'Markersize', 20);
    hold on
end

% Plot central agent
plot(0, 0, 'k.', 'Markersize', 80)
axis square
xlim([- 2 2])
ylim([- 2 2])
title(['State ', num2str(state)])
hold off

end
