%% Script to evaluate the results of the optimization for the pattern formation task
%
% Used in the paper:
% "The PageRank Algorithm as a Method to Optimize Swarm Behavior through Local Analysis"
% Mario Coppola, Jian Guo, Eberhard Gill, Guido de Croon, 2019.
%
% Mario Coppola, 2018


%% Initialize
init;

%% LOAD DATA
folder = 'data_paper/patternformation/'; % Loads the data from the paper.
% If you wish to re-evaluate (which will take a long time), then set the
% following to true:
evaluate_ph1 = 0; % (Re-)evaluate. 1=evaluate. 0=use existing data-set
evaluate_ph2 = 0; % (Re-)evaluate. 1=evaluate. 0=use existing data-set

prompt = '\nWhich pattern would you like to evaluate? \n triangle4, hexagon, triangle9, T\n>> ';

pattern_name = input(prompt, 's');
n = 5; % Number of evolutions stored
save_datasets = 0;
save_figures = 1; % Save figures as eps. 1=yes. 0=no.
color = {[0 0 0], [1 0 0], [0 0.5 0], [0 0 1], [1 0.5 0], [0.75, 0, 0.75]};

%% PHASE 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               PHASE 1                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Load evolution logs
evo_q = cell(1, n);
for i = 1:n
    fprintf('Reading log %d\n', i);
    evo_q{i} = load([folder, 'evolutions_phase1/', pattern_name, '_', num2str(i), '_q.mat'], 'population_history_q', 'Q1', 's');
end
fprintf('Done reading logs of Phase 1\n')

%% Plot phase 1 evolutions
newfigure(1000, '', ['evo_phase1_', pattern_name]);
ga_analyze_history(evo_q, 'max', color);

%% Evaluate performance phase 1
if evaluate_ph1
    fprintf('\nEvaluating\n');
    n_episodes = 100;
    sml.observation = @model_pattern_local;
    sml.model = @model_pattern_global;
    sml.local_success = @flag_global;
    
    for i = 1:numel(evo_q)
        sml.des = get_local_state_id(evo_q{i}.s.link_list(evo_q{i}.s.des, :));
        if strcmp(pattern_name,'T')
            sml.n_agents = 12;
        elseif strcmp(pattern_name,'lineNE')
            sml.n_agents = 20;
        else
            sml.n_agents = evo_q{i}.s.n_agents;
        end
        evo_q{i}.stats = simulation_episode_batch_launch (sml, evo_q{i}.Q1, n_episodes, 'visualize', 0, 'verbose', 1);
    end
    if save_datasets
        make_folder(folder);
        save([folder, 'stats_phase1_', pattern_name]);
    end
end

%% Plot performance (load data of baseline)
if strcmp(pattern_name, 'triangle4') || strcmp(pattern_name, 'hexagon') || strcmp(pattern_name, 'triangle9')
    data_bl = load([folder, 'baseline/data_baseline.mat']);
elseif strcmp(pattern_name, 'T')
    data_bl = load([folder, 'baseline/T.mat']);
end
pe_q = load([folder, 'performance_evaluation/stats_q_', pattern_name], 'evo_q');
param = {'Normalization', 'probability'};

%% Plot results
if strcmp(pattern_name, 'triangle4')
    idx = 1;
elseif strcmp(pattern_name, 'hexagon')
    idx = 3;
elseif strcmp(pattern_name, 'triangle9')
    idx = 2;
else
    idx = 1;
end

h = cell(1, n);
newfigure(1001, ['hist_phase1_', pattern_name]);
for i = 1:numel(pe_q.evo_q)
    [ht, edges] = histcounts(pe_q.evo_q{i}.stats.n_steps, param{:});
    h{i} = stairs(edges,[ht,0]);
    h{i}.Color = color{i + 1};
    hold on
end
[ht, edges] = histcounts(data_bl.stats{idx}.n_steps, param{:});
h0 = stairs(edges,[ht,0],'--');
h0.Color = color{1};
h0.LineWidth = 2;

hold off;
hlegend = legend('$\mathrm{\Pi}_1^{(E1)}$',...
    '$\mathrm{\Pi}_1^{(E2)}$',...
    '$\mathrm{\Pi}_1^{(E3)}$',...
    '$\mathrm{\Pi}_1^{(E4)}$',...
    '$\mathrm{\Pi}_1^{(E5)}$',...
    '$\mathrm{\Pi}_0$',...
    'Location','NorthOutside','Orientation','Horizontal');
hlegend.NumColumns = 5;
xlabel('Actions to completion');
ylabel('Probability [-]');

%% SAVE FIGURES
if save_figures
    latex_printallfigures(get(0, 'Children'), '', 'paper_wide_half_toplegend', [1000, 1001]);
end

%% PHASE 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               PHASE 2                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% EVOLUTIONS P
color = {[0 0 0], [1 0 0], [0 0.5 0], [0 0 1], [1 0.5 0], [0.75, 0, 0.75]};
evo_p = cell(1, n);
for i = 1:n
    fprintf('Reading log %d\n', i);
    evo_p{i} = load([folder, 'evolutions_phase2/', pattern_name, '_', num2str(i), '_p.mat'], 'population_history_p', 'Q2', 's');
end
fprintf('Done reading logs of Phase 2\n')

%% Plot evolution of phase 2
newfigure(1002, '', ['evo_phase2_', pattern_name]);
ga_analyze_history(evo_p, 'max', color);

%% Evaluate phase 2
if evaluate_ph2
    fprintf('\nEvaluating\n');
    n_episodes = 100;
    sml.observation = @model_pattern_local;
    sml.model = @model_pattern_global;
    sml.local_success = @flag_global;
    
    for i = 1:numel(evo_p)
        sml.des = get_local_state_id(evo_p{i}.s.link_list(evo_p{i}.s.des, :));
        if strcmp(pattern_name,'T')
            sml.n_agents = 12;
        elseif strcmp(pattern_name,'lineNE')
            sml.n_agents = 20;
        else
            sml.n_agents = evo_q{i}.s.n_agents;
        end
        evo_p{i}.stats = simulation_episode_batch_launch (sml, evo_p{i}.Q2, n_episodes, 'visualize', 0, 'verbose', 1);
    end
    if save_datasets
        make_folder(folder)
        save([folder, 'stats_phase2_', pattern_name]);
    end
end

%% Plot performance after phase 2
data_bl = load([folder, 'baseline/data_baseline.mat']);
pe = load([folder, 'performance_evaluation/stats_p_', pattern_name], 'evo_p');
param = {'Normalization', 'probability'};
pe_q = load([folder, 'performance_evaluation/stats_q_', pattern_name], 'evo_q');
stats_global = load([folder, 'baseline/ANTS2018_step3_opt.mat'], 'stats');
fprintf('Loaded all data \n');

if strcmp(pattern_name, 'triangle4')
    idx = 1;
    idx_q = 2;
    param(3:4) = {'BinWidth', 5};
elseif strcmp(pattern_name, 'hexagon')
    idx = 3;
    idx_q = 5;
elseif strcmp(pattern_name, 'triangle9')
    idx = 2;
    idx_q = 2;
elseif strcmp(pattern_name, 'T')
    idx = 4;
    idx_q = 3;
end

h = cell(1, n);
newfigure(1003, '', ['hist_phase2_', pattern_name]);
for i = 1:numel(pe.evo_p)
    [ht, edges] = histcounts(pe.evo_p{i}.stats.n_steps, param{:});
    h{i} = stairs(edges,[ht,0]);
    h{i}.Color = color{i + 1};
    hold on
end

[ht, edges] = histcounts(pe_q.evo_q{idx_q}.stats.n_steps, param{:});
h0 = stairs(edges,[ht,0]);
h0.Color = color{1};
h0.LineWidth = 2;
h0.LineStyle = ':';
hold on;

if idx == 1 || idx == 3
    [ht, edges] = histcounts(stats_global.stats{4, idx}.n_steps, param{:});
    h4 = stairs(edges,[ht,0]);
    h4.LineWidth = 2;
    h4.LineStyle = '--';
end
hold off
if idx == 1 || idx == 3
    hlegend = legend('$\mathrm{\Pi}_2^{(E1)}$',...
    '$\mathrm{\Pi}_2^{(E2)}$',...
    '$\mathrm{\Pi}_2^{(E3)}$',...
    '$\mathrm{\Pi}_2^{(E4)}$',...
    '$\mathrm{\Pi}_2^{(E5)}$',...
    '$\mathrm{\Pi}_1$', ...
    '$\mathrm{\Pi}_{global}$','Location','NorthOutside','Orientation','Horizontal');
else
    hlegend = legend(...
    '$\mathrm{\Pi}_2^{(E1)}$',...
    '$\mathrm{\Pi}_2^{(E2)}$',...
    '$\mathrm{\Pi}_2^{(E3)}$',...
    '$\mathrm{\Pi}_2^{(E4)}$',...
    '$\mathrm{\Pi}_2^{(E5)}$',...
    '$\mathrm{\Pi}_1$','Location','NorthOutside','Orientation','Horizontal');
end
hlegend.NumColumns = 5;
xlabel('Actions to completion');
ylabel('Probability [-]');

%% Save figures
if save_figures
    latex_printallfigures(get(0, 'Children'), '', 'paper_wide_half_toplegend', [1002, 1003]);
end
