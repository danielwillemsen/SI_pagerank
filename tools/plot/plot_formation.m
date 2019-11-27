function plot_formation(state_global)
% plot_formation plots the position of all agents given their global coordinates, 
% including the boundary, so that it's easier to see the pattern that they form.
% 
% Mario Coppola, 2018

state = state_global;
plot(state(:,1), state(:,2),'r.','Markersize',10)
xlim([-20+state(1,1) 20+state(1,1)]);
ylim([-20+state(1,2) 20+state(1,2)]);
grid minor; grid on; drawnow; hold off;

end