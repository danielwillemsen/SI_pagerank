function action_steps = simulation_episode_pattern(sim, state_global, Q, varargin)
% simulation_episode perform one simulation episode of the task for a given policy Q and returns the number of actions taken.
% Also includes the option to output figures with the patter
%
% Mario Coppola, 2018

visualize = checkifparameterpresent(varargin, 'visualize', 0, 'array');
plot_trial = checkifparameterpresent(varargin, 'visualize', 0, 'array'); % 1=trial will be plotted and saved at the end

n_steps = 0;
state_global_n = state_global;
selected_agent = 0;

if plot_trial
    statehistory_x = zeros(1,size(state_global,1));
    statehistory_y = zeros(1,size(state_global,1));
end

state_local_n = globalstate_to_observation_pattern(sim, state_global);
state_change = zeros(size(state_local_n));
damn = 0;
action_steps = 0;

max_static = 1000;

while action_steps < inf
 
    n_steps = n_steps + 1;
 
    state_local = state_local_n;
 
    damn = damn + 1;
    if any(state_change)
        damn = 0;
    end
 
    selected_agent = select_moving_agent(Q, state_local, selected_agent);
    state_change = zeros(size(state_local));
    if plot_trial
        statehistory_x(n_steps,:) = state_global_n(:,1)';
        statehistory_y(n_steps,:) = state_global_n(:,2)';
    end
    if selected_agent > 0 % If someone can move
        action_idx = block_animation_selectaction(Q, state_local(selected_agent));
        if action_idx > 0 % If that someone selects an action
            action_steps = action_steps + 1;
            state_global_n(selected_agent, :) = sim.model(state_global(selected_agent, :), action_idx);
            state_local_n = globalstate_to_observation_pattern(sim, state_global_n);
            state_change = any(abs(state_local_n - state_local), 2);
            if check_all_happy(sim, state_local_n)
                if plot_trial
                    statehistory_x(n_steps,:) = state_global_n(:,1)';
                    statehistory_y(n_steps,:) = state_global_n(:,2)';
                end
                if visualize
                    newfigure(1);plot_formation(state_global_n);
                    keyboard
                end
                break;
            end
        end
    end
 
    if visualize
        plot_formation(state_global_n);
    end

    if damn > max_static
        fprintf('\n Virtual deadlock reached! No agent moved for %d steps', max_static)
        action_steps = inf;
        break;
    end
    state_global = state_global_n; % Prepare for next step
 
end

if ~ exist('state_local_n', 'var')
    state_local_n = state_local;
end

% Plot the history of the run in a 3D plot
if plot_trial
    statehistory_x(n_steps+1:n_steps+5,:) = repmat(statehistory_x(n_steps,:),5,1);
    statehistory_y(n_steps+1:n_steps+5,:) = repmat(statehistory_y(n_steps,:),5,1);
    newfigure(1,'',['globalpath_',num2str(numel(state_local_n)),'_',num2str(randi(1000))])
    for i = 1:numel(state_local_n)
        plot3(1:n_steps+5,statehistory_x(:,i),statehistory_y(:,i),'-','Markersize',10);hold on
    end
    plot3(repmat(1,1,numel(state_local_n)),statehistory_x(1,:),statehistory_y(1,:),'ro','Markersize',30);hold on
    plot3(repmat(n_steps+5,1,numel(state_local_n)),statehistory_x(end,:),statehistory_y(end,:),'g.','Markersize',50);hold on
    xlabel('Time step')
    ylabel('East [-]')
    zlabel('North [-]')
    xlim([0,n_steps+5])
    set(gca,'Ydir','reverse')
    grid on
    latex_printallfigures(get(0,'Children'), '', 'paper_square_fourth',1);
end

end
