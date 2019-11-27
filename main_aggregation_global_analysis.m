%% Script to analyze the results of the evolutions using PageRank for the aggregation task
%
% Used in the paper:
% "The PageRank Algorithm as a Method to Optimize Swarm Behavior through Local Analysis"
% Mario Coppola, Jian Guo, Eberhard Gill, Guido de Croon, 2019.
%
% Mario Coppola, 2019

init;

%% Read logs
p1 = 0.3:0.1:1.0; % p0
p2 = 0.3:0.1:1.0; % p1
c = permn(p1,2);
aw = 30;
n_agents = 20;
reload = 0;
data_folder = 'data_paper/aggregation/evaluations/';

if reload
    data_read_folder_logs = [data_folder,'aggregation_logs_aw',...
        num2str(aw),'_n',num2str(n_agents),'/aggregation_log_'];
    logs = cell(numel(p1),numel(p2));
    for i = 1:numel(p1)
        for j = 1:numel(p2)
            st = sprintf('%2.2f_%2.2f_%d',p1(i),p2(j),aw);
            fprintf('Reading ... %s\n',st);
            f_logs = readlogs(dir([data_read_folder_logs,st,'/*.txt']), 6);
            logs{i,j} = f_logs;
        end
        make_folder(data_folder);
        save([data_folder,'aggregation_logs_aw',num2str(aw),'_n',num2str(n_agents),'.mat'],'logs','c','aw');
    end
else
    load([data_folder,'aggregation_logs_aw',num2str(aw),'_n',num2str(n_agents),'.mat']);
end
%% Get endtimes

endtime = zeros([size(logs),numel(logs{1})]);
t_mean = zeros(size(logs));
for i = 1:numel(p1)
    for j = 1:numel(p2)
        endtime(i,j,:) = get_endtime(logs{i,j}, 1);
        t_mean(i,j) = mean(endtime(i,j,:));
    end
end
fprintf('Found all end times. \n')

%% Plot fitness landscape from experiments
fignum = 12;
sc = size(c,1);
newfigure(fignum,'',['aggregation_globaltest_aw',num2str(aw),'_n',num2str(n_agents),'_3d']);

h = surf(p1,p2,t_mean);
za = zlabel('$\bar{t}_c [s]$');
view(115,43);

xa = xlabel('$p_{walk}(m=0)$');
ya = ylabel('$p_{walk}(m=1)$');
colormap jet
xticks(0:0.2:1.0)
yticks(0:0.2:1.0)

ax = struct('Axes', gca);
align_axislabel([], ax)
set(gca, 'position', [0.13, 0.1100, 0.7750, 0.8150]);
set(xa, 'Units', 'Normalized', 'Position', [1.055, 0.12, 0]);
set(ya, 'Units', 'Normalized', 'Position', [0.25, -0.05, 0]);
set(za, 'Units', 'Normalized', 'Position', [-.21, 0.32, 0]);
latex_printallfigures(get(0, 'Children'), '', 'paper_square_fourth', [12 ]);


%% Fitness landscape from fitness function

p1 = 0.3:0.1:1.0;
p2 = 0.3:0.1:1.0;
c = permn(p1,2);
s.maxneighbors = 6;
s.des = [];
s.states = [1:s.maxneighbors+1];
Q0 = zeros(7,2);
Q0(3:end,1) = 1;
fitness = zeros(numel(p1),numel(p2));
for i = 1:numel(p1)
    for j = 1:numel(p2)
        Qt = Q0;
        Qt(1,1) = 1-p1(i);
        Qt(2,1) = 1-p2(j);
        Qt(1,2) = p1(i);
        Qt(2,2) = p2(j);
        fitness(i,j) = fitness_aggregation_centrality(Qt, s);
    end
end
disp('Done')

%% Plot fitness landscape from fitness function
fignum = 15;
sc = size(c,1);
newfigure(fignum,'','aggregation_globaltest_3d');

h = surf(p1,p2,1./fitness);
za = zlabel('1/F');
view(115,43);

xa = xlabel('$p_{walk}(m=0)$');
ya = ylabel('$p_{walk}(m=1)$');
colormap jet

ax = struct('Axes', gca);
align_axislabel([], ax)
set(gca, 'position', [0.13, 0.1100, 0.7750, 0.8150]);
set(xa, 'Units', 'Normalized', 'Position', [1.07, 0.12, 0]);
set(ya, 'Units', 'Normalized', 'Position', [0.25, -0.05, 0]);
set(za, 'Units', 'Normalized', 'Position', [-.23, 0.32, 0]);
grid on
grid minor
xticks(0:0.2:1.0)
yticks(0:0.2:1.0)
%
latex_printallfigures(get(0, 'Children'), '', 'paper_square_fourth', [15 ]);

