function plot_formation_consensus(bw, s0_l, pattern)
% plot_formation plots the position of all agents given their global coordinates,
% including the boundary, so that it's easier to see the pattern that they form.
%
% Mario Coppola, 2018

col = {'r','g','k'};
for i = 1:bw
    a = find(s0_l == i);
    plot(pattern(a,1), pattern(a,2),[col{i},'.'],'Markersize',20)
    hold on
    
    xlim([-20 20]);
    ylim([-20 20]);
end
grid minor;
grid on;
drawnow;
hold off;

end