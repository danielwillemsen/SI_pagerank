%% Script to analyze the evolution and simulations after Phase 3 for the pattern formation task
%
% Used in the paper:
% "The PageRank Algorithm as a Method to Optimize Swarm Behavior through Local Analysis"
% Mario Coppola, Jian Guo, Eberhard Gill, Guido de Croon, 2018.
%
% Mario Coppola, 2018

%% Initialize
init;

%% Set up input variables
prompt = '\n\nWhich pattern would you like to use? \n triangle4, hexagon, triangle9\n>> ';
pattern_name = input(prompt, 's');
evaluate = 0;
save_figures = 1;
save_data = 0;
nlog = 5;
data_read_folder = 'data_paper/patternformation/';
data_write_folder = 'data/patternformation/';

%% Load data
load([data_read_folder, 'evolutions_phase2/', pattern_name, '_', num2str(nlog), '_p.mat'],'-regexp', '^(?!folder)\w');

sml.des = get_local_state_id(s.link_list(s.des, :));
sml.n_agents = s.n_agents;
sml.observation = @model_pattern_local;
sml.model = @model_pattern_global;

%% Evaluate
v = 1:50:1000; % Evaluate every x generations (default 50)

if evaluate
    for k = 1:nlog
        load([data_read_folder, 'evolutions_phase2/', pattern_name, '_', num2str(k), '_p.mat'],'-regexp', '^(?!folder)\w');
     
        Q2t_v = cell(1, numel(v));
        Q2t_ev = cell(1, numel(v));
        j = 0;
        for i = v
            j = j + 1;
            Q2t_v{j} = ga_phase2_get_best(population_history_p, Q1t, 'max', Qidx, i);
            Q2 = zeros(255, 8);
            Q2(get_local_state_id(s.link_list), :) = Q2t_v{j};
            Q2t_ev{j} = simulation_episode_batch_launch (sml, Q2, 50, 'visualize', 0, 'verbose', 1);
        end
        if save_data
            make_folder(data_read_folder);
            save([data_read_folder, 'performance_evaluation/', pattern_name, '_p_performance_evaluation_', num2str(k)]);
        end
        fprintf('Loaded\n')
    end
end

%% Plot Performance VS evolution.
color = {[0 0 0], [1 0 0], [0 0.5 0], [0 0 1], [1 0.5 0], [0.75, 0, 0.75]};

tmp = load([data_read_folder, 'performance_evaluation/', pattern_name, '_p_performance_evaluation_', num2str(1), '.mat'], 'Q2t_v');
v = 1:1000/numel(tmp.Q2t_v):1000;
newfigure(100, '', [pattern_name, '_phase2_performance_evaluation']);
pt = zeros(nlog, numel(v));
for k = 1:nlog
    temp{k} = load([data_read_folder, 'performance_evaluation/', pattern_name, '_p_performance_evaluation_', num2str(k), '.mat'], 'Q2t_v', 'Q2t_ev');
    for i = 1:numel(temp{k}.Q2t_v)
        pt(k, i) = mean(temp{k}.Q2t_ev{i}.n_steps);
    end
end
if strcmp(pattern_name, 'hexagon')
    plot(v, 117.58 * ones(size(v)), 'k--'); % add the globally optimized performance from ANTS 2018 results
    hold on
elseif strcmp(pattern_name, 'triangle4')
    plot(v, 8.13 * ones(size(v)), 'k--');
    hold on
end

for k = 1:nlog
    plot(v, pt(k, :), 'color', [color{k + 1}]);
    hold on;
end

if  strcmp(pattern_name, 'hexagon') || strcmp(pattern_name, 'triangle4')    
    hlegend = legend('$\mathrm{\Pi}_{global}$',...
        '$\mathrm{\Pi}_2^{(E1)}$',...
        '$\mathrm{\Pi}_2^{(E2)}$',...
        '$\mathrm{\Pi}_2^{(E3)}$',...
        '$\mathrm{\Pi}_2^{(E4)}$',...
        '$\mathrm{\Pi}_2^{(E5)}$',...
        'Location','NorthOutside','Orientation','Horizontal');
    hlegend.NumColumns = 4;
else
    hlegend = legend('$\mathrm{\Pi}_2^{(E1)}$',...
        '$\mathrm{\Pi}_2^{(E2)}$',...
        '$\mathrm{\Pi}_2^{(E3)}$',...
        '$\mathrm{\Pi}_2^{(E4)}$',...
        '$\mathrm{\Pi}_2^{(E5)}$',...
        'Location','NorthOutside','Orientation','Horizontal');
    hlegend.NumColumns = 4;
end

xlabel('Generation')
ylabel('Mean cumulative actions');

%% Save figures
if save_figures
    latex_printallfigures(get(0, 'Children'), '', 'paper_square_fourth', [100]);
end
