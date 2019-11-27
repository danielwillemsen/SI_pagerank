% Script to quickly evaluate the results of a given evolution.
% Mainly used for quick evaluation, not for the final one (dedicated scripts are available for that).
%
% Mario Coppola, 2018

%% Set up simulation parameters
sml.des = get_local_state_id(s.link_list(s.des, :));
sml.n_agents = s.n_agents;
sml.observation = @model_pattern_local;
sml.model = @model_pattern_global;
n_episodes = 100; % Number of runs
param = {'visualize', 0, 'verbose', 1};

%% Evaluate after Phase 2 using simulator
stats{1} = simulation_episode_batch_launch (sml, Q0, n_episodes, param{:});
stats{2} = simulation_episode_batch_launch (sml, Q1, n_episodes, param{:});
stats{3} = simulation_episode_batch_launch (sml, Q2, n_episodes, param{:});

%% Plot Histogram
color = ['b', 'r', 'k'];
param = {'Normalization', 'probability', 'DisplayStyle', 'stairs'};

newfigure(4, '', [pattern_name, '_', num2str(runtime_ID), '_simulations']);
h1 = histogram(stats{1}.n_steps, param{:}); hold on
h2 = histogram(stats{2}.n_steps, param{:});
h3 = histogram(stats{3}.n_steps, param{:});
h1.EdgeColor = color(1);
h2.EdgeColor = color(2);
h3.EdgeColor = color(3);
legend('$\mathrm{\Pi}_f$', '$\mathrm{\Pi}_1$', '$\mathrm{\Pi}_2$')
xlabel('Actions')
ylabel('Probability')

%% Save all data and plots

fprintf('\n');
make_folder(datafolder);
save([datafolder, pattern_name, '_', num2str(runtime_ID), '_simulations.mat']);
