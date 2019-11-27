%% Script to test the evolution result for the consensus task (binary variant) evolved with PageRank
%
% Used in the paper:
% "The PageRank Algorithm as a Method to Optimize Swarm Behavior through Local Analysis"
% Mario Coppola, Jian Guo, Eberhard Gill, Guido de Croon, 2019.
%
% Mario Coppola, 2019

%% Initialize
init;

%% Set up input variables
fprintf('---- Starting Evaluation ----\n');
data_write_folder = 'data/consensus/evaluations/';
data_read_folder  = 'data_paper/consensus/evaluations/';
save_data = 0;
save_figures = 1;
n_agents = [5 10 15 20]; % number of robots in the swarm
s.bw = 2; % Number of m options
reload_2D = 0;
reload_3D = 0;

%% Set up parameters
fprintf('Running tests\n');
[~, s, Q0] = initialize_parameters_consensus_binary(1, s);

%% 2D
if reload_2D
    p = 0.1:0.1:1.0;
    sml.des = s.des;
    sml.bw = s.bw;
    sml.states = s.states;
    param_sim = { 'type', 'consensus_binary', 'visualize', 0, 'verbose', 0};
    n_episodes = 100; % Number of runs
    stats = cell(numel(p),numel(n_agents));
    for i = 1:numel(p)
        for k = 1:numel(n_agents)
            fprintf('Testing %2.2f for %d robots\n',p(i),n_agents(k))
            Q = Q0;
            Q(1,1) = 1-p(i); % p not to change
            Q(1,2) = p(i); % p to change
            Q(3,1) = p(i); % p to change
            Q(3,2) = 1-p(i); % p not to change
            sml.n_agents = n_agents(k);
            stats{i,k} = simulation_episode_batch_launch (sml, Q, n_episodes, param_sim{:});
        end
    end
    
    if save_data
        make_folder(data_write_folder);
        save([data_write_folder,'consensus_binary_globalevaluation',num2str(n_agents,'_%d'),'.mat']);
        fprintf('Saved data\n')
    end
else
    load([data_read_folder,'consensus_binary_globalevaluation',num2str(n_agents,'_%d'),'.mat']);
    fprintf('Loaded data\n')
end
%% 2D stats mean
stats_mean = zeros(numel(p),numel(n_agents));
for i = 1:numel(p)
    for k = 1:numel(n_agents)
        stats_mean(i,k) = mean(stats{i,k}.n_steps);
    end
end
disp('Done')

%% 2D Figure
color = {[0 0 0], [1 0 0], [0 0.5 0], [0 0 1], [1 0.5 0], [0.75, 0, 0.75]};
symbol = {'o-','x-','d-','s-'};
newfigure(1,'','consensus_binary_global_2D');
for i = 1:numel(n_agents)
    plot(p,stats_mean(:,i),symbol{i},'color',color{i})
    hold on
end
ylabel('Mean cumulative actions')
xlabel('Probability of switching choice')
legend('5 robots', '10 robots', '15 robots', '20 robots')
hold off
xlim([0 1.0])
xticks(0:0.2:1.0)

%% 2D
n_agents = 10;
if reload_3D
    p1 = 0.1:0.1:1.0;
    p2 = 0.1:0.1:1.0;
    sml.des = s.des;
    sml.bw = s.bw;
    sml.states = s.states;
    param_sim = { 'type', 'consensus_binary', 'visualize', 0, 'verbose', 0};
    n_episodes = 100; % Number of runs
    stats_3D = cell(numel(p1),numel(p2),numel(n_agents));
    for i = 1:numel(p1)
        for j = 1:numel(p2)
            for k = 1:numel(n_agents)
                fprintf('Testing [%2.2f, %2.2f] for %d robots\n',p1(i),p2(j),n_agents(k))
                Q = Q0;
                Q(1,1) = 1-p1(i); % p not to change
                Q(1,2) = p1(i); % p to change
                Q(3,1) = p2(j); % p to change
                Q(3,2) = 1-p2(j); % p not to change
                sml.n_agents = n_agents(k);
                stats_3D{i,j,k} = simulation_episode_batch_launch (sml, Q, n_episodes, param_sim{:});
            end
        end
    end
    
    if save_data
        make_folder(data_write_folder);
        save([data_write_folder,'consensus_binary_globalevaluation_3D',num2str(n_agents,'_%d'),'.mat']);
        fprintf('Saved data\n')
    end
else
    load([data_read_folder,'consensus_binary_globalevaluation_3D',num2str(n_agents,'_%d'),'.mat']);
    fprintf('Loaded data\n')
end
%% 3D stats mean
stats_3D_mean = zeros(numel(p1),numel(p2),numel(n_agents));
for i = 1:numel(p)
    for j = 1:numel(p2)
        for k = 1:numel(n_agents)
            stats_3D_mean(i,j,k) = mean(stats_3D{i,j,k}.n_steps);
        end
    end
end
disp('Done')

%% 3D Figure
st = 1;
newfigure(2,'','consensus_binary_global_3D');
for i = 1
    surf(p1(st:end),p2(st:end),stats_3D_mean(st:end,st:end))
    hold on
end
za = zlabel('Mean cumulative actions');
xa = xlabel('$P(a_B | s_{A0})$');
ya = ylabel('$P(a_A | s_{B0})$');
hold off
grid on;

view([113 20])
ax = struct('Axes', gca);
align_axislabel([], ax)
set(gca, 'position', [0.15, 0.15, 0.7750, 0.8150]);
xlim([0 1.0])
ylim([0 1.0])
set(xa, 'Units', 'Normalized', 'Position', [0.95, -0.02, 0]);
set(ya, 'Units', 'Normalized', 'Position', [0.25, -0.1, 0]);
set(za, 'Units', 'Normalized', 'Position', [-0.16, 0.4, 0]);

xticks(0:0.2:1.0)
yticks(0:0.2:1.0)

%
if save_figures
    latex_printallfigures(get(0, 'Children'), '', 'paper_square_fourth', [1 2]);
end
