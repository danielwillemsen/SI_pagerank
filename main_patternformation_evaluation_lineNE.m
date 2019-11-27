%% Script to evaluate the results of the optimization for the pattern formation task for the line pattern
%
% Used in the paper:
% "The PageRank Algorithm as a Method to Optimize Swarm Behavior through Local Analysis"
% Mario Coppola, Jian Guo, Eberhard Gill, Guido de Croon, 2018.
%
% Mario Coppola, 2018


%% Initialize
init;

%% Load data
folder = 'data_paper/patternformation/';
pattern_name = 'lineNE'; % Pattern evolved
n            = 1; % Number of evolutions stored
evaluate     = 0; % Evaluate. 1=evaluate. 0=use existing data-set.
save_figures = 1; % Save figures as eps. 1=yes. 0=no.
save_dataset = 0; % Save dataset 1=yes. 0=no.

%% Load evolutions phase 2
color = {[0 0 0],[1 0 0],[0 0.5 0],[0 0 1],[1 0.5 0],[0.75, 0, 0.75]};
linestyle = {'-','--',':','-.'};
ratios = [1 8 18];
n_agents_vect = [5 10 20];

evo_p = cell(n,numel(ratios));
for i = 1:n
    for j = 1:numel(ratios)
        fprintf('Reading log %d ratio %d \n',i,ratios(j));
        evo_p{i,j} = load([folder,'evolutions_lineNE/',pattern_name,'_',num2str(i),'_p_ratio',num2str(ratios(j)),'.mat'],'population_history_p','Q2','s');
    end
end
fprintf('Done reading\n')

%% Plot evolutions
newfigure(600,'',['evo_p_',pattern_name]);
ga_analyze_history(evo_p(1,:),'max',color);
legend('1:1:1','1:8:1','1:18:1','Location','NorthOutside','Orientation','Horizontal');

%% Evaluate final controllers
if evaluate
    fprintf('\nEvaluating\n\n');
    n_episodes = 100;
    sml.observation    = @model_pattern_local;
    sml.model          = @model_pattern_global;
    sml.local_success  = @flag_global;
    
    for i = 1:n
        for j = 1:numel(ratios)
            for k = 1:numel(n_agents_vect)
                sml.des  = get_local_state_id(evo_p{i,j}.s.link_list(evo_p{i,j}.s.des,:));
                sml.n_agents = n_agents_vect(k);
                evo_p{i,j}.stats{k} = block_animation_episode_handler ( sml, evo_p{i,j}.Q2, n_episodes, 'visualize',0,'verbose', 1);
                fprintf('Saving...\n\n')
                if save_dataset
                    make_folder(folder);
                    save([folder,'performance_evaluation/stats_p_',pattern_name,'_i',num2str(i),'_j',num2str(j),'_k',num2str(k)]);
                end
            end
        end
    end
    fprintf('\nSaved\n');
end

%% PLOTS PERFORMANCE P
data_bl = load([folder,'baseline/lineNE_20.mat']);
pe = load([folder,'performance_evaluation/stats_p_lineNE_i1.mat'],'evo_p');
fprintf('\nLoaded Data\n')

%% Zoomed out version with baseline
lw = 1;
param = {'Normalization','Probability'};
h = cell(1,n);
newfigure(601,'',['hist_',pattern_name]);
[ht, edges] = histcounts(data_bl.stats{1}.n_steps,'Normalization','Probability');
h0 = stairs(edges,[ht,0]);
h0.Color = color{1};
h0.LineWidth = lw;
hold on
cc = 1;
clear evo_p_alt
for i = 1:size(pe.evo_p,1)
    for j = 1:numel(ratios)
        for k = 3:3
            cc=cc+1;
            % Remove inf and 500000
            evo_p_alt = pe.evo_p{i,j}.stats{k}.n_steps;
            evo_p_alt(evo_p_alt==inf) = []; % Deadlocks
            evo_p_alt(evo_p_alt==5000000) = []; % Livelocks
            [ht, edges] = histcounts(evo_p_alt,param{:});
            h{j} = stairs(edges,[ht,0]);
            h{j}.Color = color{cc};
            h{j}.LineStyle = linestyle{cc};
            h{j}.LineWidth = lw;
        end
    end
end
hold off;
hlegend = legend('$\mathrm{\Pi}_0$',...
    '$\mathrm{\Pi}_{1:1:1}$',...
    '$\mathrm{\Pi}_{1:8:1}$',...
    '$\mathrm{\Pi}_{1:18:1}$',...
    'Location','NorthOutside','Orientation','Horizontal');

% legend('$','1:1:1','1:8:1','1:18:1',...
%     'Location','NorthOutside','Orientation','Horizontal');
xlabel('Actions to completion');
ylabel('Probability [-]');

%% Plot zoomed in version without baseline
param = {'Normalization','Probability'};
h = cell(1,n);
newfigure(602,'',['hist_',pattern_name,'_comparison']);
cc = 0;
clear evo_p_alt
lw = 2;
for i = 1:size(pe.evo_p,1)
    for j = 1:numel(ratios)
        for k = 3:3
            cc=cc+1;
            % Remove inf and 500000
            evo_p_alt = pe.evo_p{i,j}.stats{k}.n_steps;
            evo_p_alt(evo_p_alt==inf) = []; % Livelocks
            evo_p_alt(evo_p_alt==5000000) = []; % Deadlocks
            [ht, edges] = histcounts(evo_p_alt,param{:});
            ht = [0 ht];
            edges = [mean(diff(edges)) edges];
            h{j} = stairs(edges,[ht,0]);
            hold on
            h{j}.Color = color{cc+1};
            h{j}.LineStyle = linestyle{cc+1};
            h{j}.LineWidth = lw;
        end
    end
end

hlegend = legend('$\mathrm{\Pi}_{1:1:1}$',...
    '$\mathrm{\Pi}_{1:8:1}$',...
    '$\mathrm{\Pi}_{1:18:1}$',...
    'Location','NorthOutside','Orientation','Horizontal');
hold off;
xlabel('Actions to completion');
ylabel('Probability [-]');

%% Save figures
if save_figures
    latex_printallfigures(get(0,'Children'),'', 'paper_square_fourth',[600 601 602]);
end
