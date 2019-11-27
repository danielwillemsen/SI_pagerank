function plot_actions(Qrow)
% plot_actions visualizes the possible actions on a plot, given a policy at state s
% 
% Mario Coppola, 2018

pp = statespace_grid;
actions = find(Qrow>0); % Get the valid actions from the policy
if ~isempty(actions)
    for k = 1:length(actions)
        quiver(0,0,pp(actions(k),1),pp(actions(k),2),...
        	'r','Linewidth',2,'MaxHeadSize',1); % Plot the actions as arrows
        hold on;
    end
end

end
