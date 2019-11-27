%% Script to analyze the results of the evolutions using PageRank for the aggregation task
%
% Used in the paper:
% "The PageRank Algorithm as a Method to Optimize Swarm Behavior through Local Analysis"
% Mario Coppola, Jian Guo, Eberhard Gill, Guido de Croon, 2019.
%
% Mario Coppola, 2019

%% Initialize
init;

%% Set up input variables
fprintf('---- Starting Evaluation ---- \n');
datafolder = 'data_paper/aggregation/'; % Where the final data will be stored
n_exp = 5;
save_figures = 1;
color = {[0 0 0], [1 0 0], [0 0.5 0], [0 0 1], [1 0.5 0], [0.75, 0, 0.75]};

%% Data evolution
fprintf('Loading evolution data\n');
data_aggregation_evolutions = cell(1,n_exp);
for i = 1:n_exp
    fname = dir([datafolder,'evolutions/aggregation_p0.5_',num2str(i),'*.mat']);
    data_aggregation_evolutions{i} = load(fname.name);
end
plot_evolution(101,data_aggregation_evolutions,'data_aggregation_evolutions');

%% Plot walk probability
fprintf('Plotting the walk probability \n');
newfigure(102,'','data_aggregation_behavior');
Qt = zeros(numel(data_aggregation_evolutions{i}.Q1(:,2)),n_exp);
for i = 1:n_exp
    Qt(:,i) = data_aggregation_evolutions{i}.Q1(:,2);
end
Qavg = mean(Qt,2);
bar(0:numel(data_aggregation_evolutions{1}.s.states)-1,Qavg,'w');
hold on
plot(0:numel(data_aggregation_evolutions{1}.s.states)-1,Qavg,'ko-','MarkerSize',8,'Linewidth',2);
hold on
xlabel('\# Neighbors')
ylabel('$p(a_{walk})$ [-]')

%% Sample runs
fprintf('Plotting some sample runs \n');
log = readlogs(dir([datafolder,'evaluations/logs_original_30/log_*.txt']), 6);

lognums = [2 6]; % Some examplary runs, which also show multiple aggregates
jj = 0;
for i = lognums
    tlim = max(log{i}(:,1)) * ones(size(lognums));
    jj = jj + 1;
    nagents = max(log{i}(:,2));
    newfigure(500+jj,'',['data_aggregation_samplelog_',num2str(jj)]);
    for ID = 1:nagents
        p = find(log{i}(:,2)==ID); % entry number
        f_ID = log{i}(p,[1 3 4]);
        t = 1:numel(p);
        time = f_ID(:,1);
        plot3(f_ID(t,1),f_ID(t,2),f_ID(t,3),'-','color','k','Linewidth',1,'MarkerSize',20);
        plot3(f_ID(1,1),f_ID(1,2),f_ID(1,3),'.','color','r','Linewidth',1,'MarkerSize',30);
        plot3(f_ID(end,1),f_ID(end,2),f_ID(end,3),'.','color','g','Linewidth',1,'MarkerSize',30);
        hold on;
    end
    grid on;
    xa=xlabel('$Time [s] \rightarrow$');
    ya=ylabel('$East [m] \rightarrow$');
    za=zlabel('$North [m] \rightarrow$');
    view([-41 38])
    ax = struct('Axes', gca);
    align_axislabel([], ax)
    set(gca, 'position', [0.2, 0.1100, 0.7750, 0.8150]);
    ylim([-20 20])
    zlim([-20 20])
    set(xa, 'Units', 'Normalized', 'Position', [0.85, 0, 0]);
    set(ya, 'Units', 'Normalized', 'Position', [0.1, 0, 0]);
    set(za, 'Units', 'Normalized', 'Position', [-0.18, 0.5, 0]);
    
    axis square
end


%% Save figures
if save_figures
    latex_printallfigures(get(0, 'Children'), '', 'paper_square_half', 500+1:numel(lognums));
    latex_printallfigures(get(0, 'Children'), '', 'paper_wide_half', [101 102]);
end