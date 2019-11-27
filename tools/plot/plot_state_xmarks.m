function plot_state_xmarks(state,xmarks)
%plot_state_xmarks Useful for debugging. This is the same as the function plot_state, only that this also plots
% (using x marks) all possible positions up to one layer beyond the local state.
% This way it is possible to explore how the agent can navigate its neighborhood.
% 
% Mario Coppola, 2018

pp = statespace_grid;

link = dec2bin(state,8)-'0';
pp(find(link==0),:) = [];
for j=1:size(pp,1)
    plot([0;pp(j,1)],[0;pp(j,2)],'k-o','Markersize',20); hold on
end

for j=1:size(xmarks,1)
    plot(xmarks(j,1),xmarks(j,2),'rx','Markersize',30); hold on
end

plot(0,0,'k.','Markersize',80)
axis square
xlim([-2 2])
ylim([-2 2])
title(['State ',num2str(state)])

end

