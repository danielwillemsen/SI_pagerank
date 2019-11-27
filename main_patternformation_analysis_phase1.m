%% Script to analyze the evolution and simulations after Phase 1 for the pattern formation task
%
% Used in the paper:
% "The PageRank Algorithm as a Method to Optimize Swarm Behavior through Local Analysis"
% Mario Coppola, Jian Guo, Eberhard Gill, Guido de Croon, 2019.
%
% Mario Coppola, 2019

%% Initialize
init;

%% Set up input variables
prompt = '\n\nWhich pattern would you like to use? \n triangle4, hexagon, triangle9\n>> ';
pattern_name = input(prompt, 's');
nlog = 5;
evaluate = 0;
save_figures = 1;
save_data = 0;
data_read_folder = 'data_paper/patternformation/';
data_write_folder = 'data/patternformtion/';

%% Evaluate
if evaluate
    for k = 1:nlog
        load([data_read_folder, 'evolutions_phase1/', pattern_name, '_', num2str(k), '_q.mat'],'-regexp', '^(?!folder)\w');
     
        sml.des = get_local_state_id(s.link_list(s.des, :));
        sml.n_agents = s.n_agents;
        sml.observation = @model_pattern_local;
        sml.model = @model_pattern_global;
     
        v = 1:50:2000;
        Q1t_v = cell(1, numel(v));
        Q1t_ev = cell(1, numel(v));
        j = 0;
        for i = v
            j = j + 1;
            Q1t_v{j} = ga_phase1_get_best(population_history_q, 'max', i);
            Q1 = zeros(255, 8);
            Q1(get_local_state_id(s.link_list), :) = Q1t_v{j};
            Q1t_ev{j} = simulation_episode_batch_launch (sml, Q1, 100, 'visualize', 0, 'verbose', 1);
        end
        if save_data
            make_folder(data_write_folder);
            save([data_write_folder, 'performance_evaluation/', pattern_name, '_q_performance_evaluation_', num2str(k)]);
        end
    end
    fprintf('Loaded\n')
end

%% Plot Performance VS evolution.
color = {[0 0 0], [1 0 0], [0 0.5 0], [0 0 1], [1 0.5 0], [0.75, 0, 0.75]};
newfigure(100, '', [pattern_name,'_phase1_performance_evaluaton']);
tmp = load([data_read_folder, 'performance_evaluation/', pattern_name, '_q_performance_evaluation_', num2str(1), '.mat'], 'Q1t_v');
v = 1:2000/numel(tmp.Q1t_v):2000;
clear tmp
pt = zeros(nlog, numel(v));
for k = 1:nlog
    temp{k} = load([data_read_folder, 'performance_evaluation/', pattern_name, '_q_performance_evaluation_', num2str(k), '.mat'], 'Q1t_v', 'Q1t_ev');
    if k == 4 && (size(temp{4}.Q1t_v,2) > size(temp{4}.Q1t_ev,2))
        temp{4}.Q1t_v(1:3) = [];
    end
    for i = 1:numel(temp{k}.Q1t_v)
        pt(k, i) = mean(temp{k}.Q1t_ev{i}.n_steps);
    end
end

% Add the globally optimized performance from ANTS 2018 results for comparison
if strcmp(pattern_name, 'hexagon')
    plot(v, 117.58 * ones(size(v)), 'k--');
    hold on
elseif strcmp(pattern_name, 'triangle4')
    plot(v, 8.13 * ones(size(v)), 'k--');
    hold on
end

for k = 1:nlog
    plot(v, pt(k, :), 'color', [color{k+1}]);
    hold on;
end

hold off

if  strcmp(pattern_name, 'hexagon') || strcmp(pattern_name, 'triangle4')    
    hlegend = legend('$\mathrm{\Pi}_{global}$',...
        '$\mathrm{\Pi}_1^{(E1)}$',...
        '$\mathrm{\Pi}_1^{(E2)}$',...
        '$\mathrm{\Pi}_1^{(E3)}$',...
        '$\mathrm{\Pi}_1^{(E4)}$',...
        '$\mathrm{\Pi}_1^{(E5)}$',...
        'Location','NorthOutside','Orientation','Horizontal');
    hlegend.NumColumns = 4;
else
    hlegend = legend('$\mathrm{\Pi}_1^{(E1)}$',...
        '$\mathrm{\Pi}_1^{(E2)}$',...
        '$\mathrm{\Pi}_1^{(E3)}$',...
        '$\mathrm{\Pi}_1^{(E4)}$',...
        '$\mathrm{\Pi}_1^{(E5)}$',...
        'Location','NorthOutside','Orientation','Horizontal');
    hlegend.NumColumns = 4;
end

xlabel('Generation');
ylabel('Mean cumulative actions');

%% Save figures
if save_figures
    latex_printallfigures(get(0, 'Children'), '', 'paper_square_fourth', 100);
end
